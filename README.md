# API

Format:
'''json
{
        "message": "What happened in the transaction",
        "data": "The content of the request"
}
'''


## GET
### Get all events
**Definition**
'GET /api/events'

**Response**
- '200 OK' on success
'''json
[
    {
        "name": "LAN party",
        "description": "LAN party for the members of the club",
        "datetime": "DD-MM-YYYY HH:MM"
    },
    {
        "name": "LAN party 2",
        "description": "LAN party for the members of the club",
        "datetime": "DD-MM-YYYY HH:MM"
    }
]
'''
Will return all events in collection

(Not yet implemented)
### Get one event
**Definition**
'GET /api/events/<identifier>'

**Response**
- '200 OK' on success
- '404 not found' on fail

'''json
{
    "name": "LAN party",
    "description": "LAN party for the members of the club",
    "datetime": "DD-MM-YYYY HH:MM"
}
'''
Will return all events in collection


### Get all pictures
**Definition**
'GET /api/pictures'

**Response**
- '200 OK' on success
'''json
[
    {
        "id": "1",
        "date": "DD-MM-YYYY"
        "file-path": "/some/path/to/picture"
    },
    {
        "id": "2",
        "date": "DD-MM-YYYY"
        "file-path": "/some/path/to/picture"
    }
]
'''
Will return all pictures in collection


## POST
### New event
**Definition**
'POST /api/events'

**Arguments**
- '"identifier":string' a unique identifier for this event
- '"name":string' the name of the event
- '"description":string' the description of the event
- '"datetime":string' the date and time of the event

**Response**
- '201 Created' on success

'''json
{
    "identifier": "lan-party",
    "name": "LAN party",
    "description": "LAN party for the members of the club",
    "datetime": "DD-MM-YYYY HH:MM"
}
'''


### New pictures
**Definition**
'POST /api/pictures'

**Arguments**
- '"date":string' the date of the of the picture
- '"filepath":string' the path to picture location

**Response**
- '200 OK' on success

'''json
{
    "date": "DD-MM-YYYY",
    "filepathe": "/some/directory/"
}
'''

## DELETE
### Events
**Definition**
'DELETE /api/events'

**Arguments**
- '"unique_identifier"'

**Response**
- '200 OK' on success

Will delete event based on unique identifier

### Pictures
**Definition**
'DELETE /api/pictures'

**Arguments**
- '"unique_identifier"'

**Response**
- '200 OK' on success

Will delete picture based on unique identifier
