# REST API Documentation

All applications deployed through the charts in this repository expose a consistent REST API interface.

## Base URL

When deployed locally with port-forwarding:
```
http://localhost:8080
```

## Endpoints

### Health Check

Check the health status of the application.

**GET** `/api/health`

#### Response
```json
{
  "status": "healthy",
  "timestamp": 1673123456,
  "service": "go-gin-api-server"
}
```

### User Management

#### List Users

**GET** `/api/users`

#### Response
```json
[
  {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com"
  },
  {
    "id": 2,
    "name": "Jane Smith",
    "email": "jane@example.com"
  }
]
```

#### Get User by ID

**GET** `/api/users/{id}`

#### Response
```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com"
}
```

#### Create User

**POST** `/api/users`

#### Request Body
```json
{
  "name": "New User",
  "email": "newuser@example.com"
}
```

#### Response
```json
{
  "id": 3,
  "name": "New User",
  "email": "newuser@example.com"
}
```

#### Update User

**PUT** `/api/users/{id}`

#### Request Body
```json
{
  "name": "Updated Name",
  "email": "updated@example.com"
}
```

#### Response
```json
{
  "id": 1,
  "name": "Updated Name",
  "email": "updated@example.com"
}
```

#### Delete User

**DELETE** `/api/users/{id}`

#### Response
```json
{
  "message": "User deleted successfully"
}
```

## Error Responses

All endpoints return consistent error responses:

```json
{
  "error": "Error message",
  "code": 400,
  "timestamp": 1673123456
}
```

## Framework-Specific Notes

While all frameworks implement the same API interface, there may be slight differences in:

- **Response timing** - Java/SpringBoot typically has higher startup times
- **Error message format** - Minor variations in error response structure
- **Performance characteristics** - Different frameworks have different performance profiles

## Testing the API

### Using curl

```bash
# Health check
curl http://localhost:8080/api/health

# List users
curl http://localhost:8080/api/users

# Create user
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com"}'
```

### Using httpie

```bash
# Health check
http GET localhost:8080/api/health

# Create user
http POST localhost:8080/api/users name="Test User" email="test@example.com"
```