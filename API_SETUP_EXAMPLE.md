# API Routes Setup Example

# Add this to config/routes.rb to enable the API endpoints:

#

# namespace :api do

# namespace :v1 do

# resources :posts

# # Add more resources here as needed:

# # resources :comments

# # resources :users

# # resources :categories

# end

# end

#

# This will generate the following routes:

# GET /api/v1/posts - list all posts (with pagination)

# POST /api/v1/posts - create a post

# GET /api/v1/posts/:id - show a post

# PATCH /api/v1/posts/:id - update a post

# PUT /api/v1/posts/:id - update a post

# DELETE /api/v1/posts/:id - delete a post

#

# Example API usage:

#

# # Create a post

# POST /api/v1/posts

# Content-Type: application/json

# {

# "post": {

# "title": "My First Post",

# "content": "This is the content",

# "published": true

# }

# }

#

# Response (201 Created):

# {

# "id": 1,

# "title": "My First Post",

# "content": "This is the content",

# "published": true,

# "summary": "This is the content",

# "word_count": 4,

# "created_at": "2026-03-01T10:00:00Z",

# "updated_at": "2026-03-01T10:00:00Z"

# }

#

# # List posts with pagination

# GET /api/v1/posts?page=1&per_page=20

#

# Response (200 OK):

# {

# "data": [

# {

# "id": 1,

# "title": "My First Post",

# ...

# }

# ],

# "meta": {

# "page": 1,

# "per_page": 20,

# "total": 100

# }

# }

#

# # Get a single post

# GET /api/v1/posts/1

#

# Response (200 OK):

# {

# "id": 1,

# "title": "My First Post",

# "content": "This is the content",

# "published": true,

# "summary": "This is the content",

# "word_count": 4,

# "created_at": "2026-03-01T10:00:00Z",

# "updated_at": "2026-03-01T10:00:00Z"

# }

#

# # Update a post

# PATCH /api/v1/posts/1

# Content-Type: application/json

# {

# "post": {

# "title": "Updated Title"

# }

# }

#

# Response (200 OK):

# {

# "id": 1,

# "title": "Updated Title",

# "content": "This is the content",

# "published": true,

# "summary": "This is the content",

# "word_count": 4,

# "created_at": "2026-03-01T10:00:00Z",

# "updated_at": "2026-03-01T10:00:00Z"

# }

#

# # Delete a post

# DELETE /api/v1/posts/1

#

# Response (204 No Content)
