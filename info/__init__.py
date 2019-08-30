# Framework
from flask import Flask, g, request, render_template, session, url_for, redirect
from flask.cli import with_appcontext
from flask_restful import Resource, Api, reqparse

# Auth security
from werkzeug.security import generate_password_hash, check_password_hash

# Other libraries
import functools
import sqlite3
import hashlib
import json
import random


# Flask setup and routing
app = Flask(__name__)
app.secret_key = b'hallila'
api = Api(app)

UPLOAD_FOLDER = '/path/to/uploads'
ALLOWED_EXTENSIONS = {'png','jpg','jpeg'}

# SQL connect
def get_db():
    if 'db' not in g:
        g.db = sqlite3.connect('database.db')
        g.db.row_factory = sqlite3.Row
    return g.db


def close_db(e=None):
    db = g.pop('db', None)

    if db is not None:
        db.close()

def login_required(view):
    @functools.wraps(view)
    def wrapped_view(**kwargs):
        if g.user is None:
            return redirect(url_for('login'))

        return view(**kwargs)

    return wrapped_view

@app.before_request
def load_logged_in_user():
    user_id = session.get('user_id')

    if user_id is None:
        g.user = None
    else:
        g.user = get_db().execute("SELECT * FROM admin WHERE Id = ?", (user_id,)).fetchone()

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


# Routing
@app.route('/')
def Index():
    return render_template('base.html')

@app.route('/login', methods=('GET', 'POST'))
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        sql = get_db()
        error = None
        user = sql.execute('SELECT * FROM admin WHERE username = ?', (username,)).fetchone()

        if user is None:
            error = 'Forkert brugernavn'
        elif not user['password'] == password:
            error = 'Forkert adgangskode'

        if error is None:
            session.clear()
            session['user_id'] = user['Id']
            return redirect(url_for('Admin'))

    return render_template('login.html')

@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('login'))

@app.route('/admin')
@login_required
def Admin():
    return render_template('admin.html')

#@app.route('pic')

# REST Api
class EventList(Resource):
    def get(self):
        sql = get_db()
        sqlstatement = "SELECT * FROM events"
        result = sql.execute(sqlstatement).fetchall()

        events = []

        for row in result:
            events.append({'id':row[0],'name':row[1],'description':row[2],'eventdate':row[3]})

        return json.dumps({'data': events}), 200

    def post(self):
        parser = reqparse.RequestParser()

        parser.add_argument('name', required=True)
        parser.add_argument('description', required=True)
        parser.add_argument('eventdate', required=True)

        args = parser.parse_args()

        sql = get_db()
        sqlstatement = 'INSERT INTO events (name, description, eventdate,unique_identifier) VALUES (?,?,?,?)'

        string = args['name'] + args['eventdate'] + str(random.random())

        identifier = hashlib.sha256(string.encode())

        sql.execute(sqlstatement,(args['name'],args['description'],args['eventdate'], identifier.hexdigest()))
        sql.commit()
        return {'message': 'Event tilføjet', 'data': args}, 201

    def delete(self):
        parser = reqparse.RequestParser()

        parser.add_argument('unique_identifier', required=True)
        args = parser.parse_args()

        sql = get_db()
        sqlstatement = "DELETE FROM events WHERE ?"

        sql.execute(sqlstatement, args['unique_identifier'])
        sql.commit()

        return {'message': 'Event slettet'}, 200

class PictureList(Resource):
    def get(self):
        sql = get_db()
        sqlstatement = "SELECT * FROM pictures"
        result = sql.execute(sqlstatement).fetchall()

        pictures = []

        for row in result:
            pictures.append({'id':row[0],'date':row[1],'filepath':row[2]})

        return json.dumps({'data': pictures}), 200

    def post(self):
        parser = reqparse.RequestParser()

        parser.add_argument('date', required=True)
        parser.add_argument('filepath', required=True)

        args = parser.parse_args()

        sql = get_db()
        sqlstatement = 'INSERT INTO events (date, filepath, unique_identifier) VALUES (?,?,?)'

        string = args['date'] + args['filepath'] + str(random.random())

        identifier = hashlib.sha256(string.encode())

        sql.execute(sqlstatement,(args['date'],args['filepath'],identifier))
        sql.commit()
        return {'message': 'Billede tilføjet', 'data': args}, 201

    def delete(self):
        parser = reqparse.RequestParser()

        parser.add_argument('unique_identifier', required=True)
        args = parser.parse_args()

        sql = get_db()
        sqlstatement = "DELETE FROM pictures WHERE ?"

        sql.execute(sqlstatement, args['unique_identifier'])
        sql.commit()
        return {'message': 'Billede slettet'}, 200

api.add_resource(EventList, '/api/events')
api.add_resource(PictureList,'/api/pictures')
