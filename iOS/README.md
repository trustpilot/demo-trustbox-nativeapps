# iOS app

## Using a TrustBox for web in an app

While the TrustBoxes (our widgets that show TrustScore, stars, reviews etc.) are designed to be used on web sites they can work just as well in a native mobile app. Using the [WKWebView](https://developer.apple.com/reference/webkit/wkwebview) from the iOS WebKit SDK the TrustBox can be used to easily show some Trustpilot data in your app.

In this demo app a TrustBox Mini Carousel has been implemented. Using the Main.storyboard to lay out the necessary views and the FirstViewController.swift to hook it all up. The implementation is done in these:

### Setting up the TrustBox

1. Get the code for the TrustBox to implement. There are two parts; a `<script>` tag and a `<div>` tag. Get these code snippets from our business product under Integrations > TrustBoxes.

2. In the `<script>` tag is a URL to the TrustBox bootstrap code. This URL is protocol-relative meaning it doesn't have a defined `http:` or `https:`, it just uses whatever the host web site uses. That won't work in a native mobile app, so add `https:` to the URL: **https**://widget.trustpilot.com/bootstrap/v5/tp.widget.bootstrap.min.js

3. Load the HTML in the web view using the loadHTMLString method:

  ```js
  let trustboxScript = "..."

  let trustboxWidget = "..."

  trustboxWebView?.loadHTMLString(trustboxScript + trustboxWidget, baseURL: nil)
  ```

4. The last step is to allow the app to load data from the web. By default iOS will (block requests to arbitrary URLs.)[https://developer.apple.com/library/prerelease/content/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html] There are two ways two get around this. In info.plist either:
  1. Add a NSAppTransportSecurity section and within that, set NSAllowsArbitraryLoads to YES
  2. Add a NSAppTransportSecurity section and a NSExceptionDomains dictionary. In that dictionary add the domain trustpilot.com

  Both settings are implemented in this app.

**That's it!** You have a TrustBox in your app!

Depending on your app's layout it might not look pretty though. Here are a few tips.

**Disable scrolling in the web view.**
Get rid of any bouncing scroll which has a weird feeling to it. Disable scroll in the web views internal UIScrollView like so:

```js
trustboxWebView?.scrollView.isScrollEnabled = false
```


**Add a viewport meta tag to the web view.** With this extra little bit of HTML in the web view, we let the renderer know how wide we want the viewport to be. That means the TrustBox can be set to 100% width and take up the full width.

```js
let metaTag = String(format:"<meta name=\"viewport\" content=\"width=%f, shrink-to-fit=YES\">", (trustboxWebView?.frame.width)!)
let trustboxScript = "..."
let trustboxWidget = "..."

trustboxWebView?.loadHTMLString(metaTag + trustboxScript + trustboxWidget, baseURL: nil)
```

**Handle navigation from links in the TrustBox.** Any links in the TrustBox are swallowed by iOS. To handle links being tapped, implement [WKWebViewNavigationDelegate](https://developer.apple.com/reference/webkit/wknavigationdelegate).

With this delegate links can be made to open in Safari or switch to another view in the app. Whatever makes sense.
