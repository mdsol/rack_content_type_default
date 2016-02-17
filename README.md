# Rack::ContentTypeDefault

Rack::ContentTypeDefault is a tiny piece of middleware that sets default `CONTENT-TYPE:` header when it isn't present
for specific requests. It checks if a content type is set and does not override the existing one.

The following options may be specified:

1. Request method(s) on which the content type is applied. The default value is post.
2. Desired content type. The default value is 'application/json'.
3. Paths on which the content type is applied. The default is all paths when none are specified.
4. A boolean value to indicate whether or not to apply 'application/xml' or 'application/json' if the path ends in .xml
    or .json, respectively. The default value is false.


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
