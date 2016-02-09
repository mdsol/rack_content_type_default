# Rack::ContentTypeDefault

Rack::ContentTypeDefault is a tiny piece of middleware that sets default `CONTENT-TYPE:` header when it isn't present
for specific requests. It checks if a content type is set and does not override the existing one.
The options allow you to specify the request methods and the content type to be set. The options also allow you to set
content type only for requests with certain paths. In addition, the options allow  you to set content type to
application/xml or application/json if possible based on the path.

The code has been copied and adapted from https://gist.github.com/tstachl/6264249

## Installation

### rubygems

TBD

## Usage
Examples:

```
require 'rack/content-type-default`
config.middleware.use Rack::ContentTypeDefault, :post, 'application/x-www-form-urlencoded'
```

```
require 'rack/content-type-default`
config.middleware.use Rack::ContentTypeDefault, [:get, :post], 'application/xml', '/authenticate.xml'
```

```
require 'rack/content-type-default`
config.middleware.use Rack::ContentTypeDefault, :post, 'application/json', ['/authenticate.json', '/show'], true
```

## Why

It is useful if you want to make your application opinionated about the content type it expects from clients when not
provided. In addition it bridges a gap between test and production environments if the clients differ.
