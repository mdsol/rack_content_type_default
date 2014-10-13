# Rack::ContentTypeDefault

Rack::ContentTypeDefault is a tiny piece of middleware that sets default `CONTENT-TYPE:` header when it isn't present
for specific methods. It checks if a content type is set and does not override the existing one.
The options allow you to specify the request methods, and the content type to be set.

The code has been copied and adapted from https://gist.github.com/tstachl/6264249

## Installation

### rubygems

TBD

## Usage
Example:

```
require 'rack/content-type-default`
config.middleware.use Rack::ContentTypeDefault, :post, 'application/x-www-form-urlencoded'
```

## Why

It is useful if you want to make your application opinionated about the content type it expects from clients when not
provided. In addition it bridges a gap between test and production environments if the clients differ.
