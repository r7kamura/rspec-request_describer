## 0.0.10
- Private APIs `#request_body`, `#env`, `#endpoint_segments`, `#method` and `#path`
  are now prefixed with `_` to avoid name collision and override of `Object#method`.

## 0.0.9
- Ignore case-sensivity on Content-Type checking

## 0.0.8
- Use more sophisticated method capture pattern

## 0.0.7
- Add `send_request` to explicitly call `subject` (Thx @lazywei)

## 0.0.6
- Allow any non-space characters in URL path

## 0.0.5
- Allow hyphen in path

## 0.0.4
- Define HTTPS as reserved header name

## 0.0.3
- Remove dependency on ActiveSupport's `Object#in?`

## 0.0.2
- Support RSpec 3

## 0.0.1
- 1st Release
