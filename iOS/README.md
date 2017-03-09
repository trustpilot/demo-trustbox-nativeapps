# iOS app

## Using a TrustBox for web in an app

While the TrustBoxes (our widgets that show TrustScore, stars, reviews etc.) are designed to be used on web sites they can work just as well in a native mobile app. Using the [WKWebView](https://developer.apple.com/reference/webkit/wkwebview) from the iOS WebKit SDK the TrustBox can be used to easily show some Trustpilot data in your app.

In this demo app a TrustBox Mini Carousel has been implemented. Using the Main.storyboard to lay out the necessary views and the FirstViewController.swift to hook it all up.

### Setting up the TrustBox

1. Get the code for the TrustBox to implement. There are two parts; a `<script>` tag and a `<div>` tag. See [how to choose a TrustBox](https://support.trustpilot.com/hc/articles/204123713) in our support center

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


## Using the Trustpilot API

We have a public API that can be used to build custom versions of the TrustBoxes. Essentially the TrustBoxes are built on these APIs. Through the APIs you can get details about a company on Trustpilot such as their TrustScore, number of reviews and current star rating. You can also request reviews that can then be displayed in your app.

The demo app uses two endpoints on our API, one to get a business unit ([what's a business unit?](https://developers.trustpilot.com/#BusinessUnit)) with details about star rating, TrustScore etc, and one to get the latest reviews for that business unit. The business unit the app is using is trustpilot.com - the business unit id is defined in the `configuration.plist` file. This is also where the API key is stored.

The API calls are implemented in the [TrustpilotApi.swift](TrustBoxInNativeApp/TrustpilotApi.swift) file. The API requests are simple HTTP GET requests in this case done by using the [URLRequest](https://developer.apple.com/reference/foundation/urlrequest). Responses from the API are in JSON which is easily handled in iOS by using [JSONSerialization](https://developer.apple.com/reference/foundation/jsonserialization).

All that is left after calling the API and deserializing the response data is unwrapping the data and using it in a view. The [SecondViewController.swift](TrustBoxInNativeApp/SecondViewController.swift) is an example of that. The JSON data is deserialized to a dictionary with `String` keys and `Any` values. Getting a specific value can be done like this:

```js
let stars = dictionary["stars"] as! NSNumber
```

Since HTTP requests are asynchronous the TrustpilotApi methods take a callback, which is called when a response comes back. In iOS this happens on a different thread from the UI. That means that to update the UI with data from the API, use the DispatchQueue to get back on the main thread. It's still a good idea to update the UI asynchronously though, so the app doesn't become unresponsive.

```js
DispatchQueue.main.async {
  self.updateView(...)
}
```

The DispatchQueue is part of [Grand Central Dispatch.](https://developer.apple.com/reference/dispatch)


### Showing reviews

[ReviewPageViewController.swift](TrustBoxInNativeApp/RReviewPageViewController.swift) is an example of getting reviews from the API and showing them in a view. The process is the same as above. The reviews endpoint on the API can be filtered in a lot of ways. For example to only return 4- and 5-star reviews, latest 5 reviews, reviews with a specific tag etc.


### Notes & references

To use our APIs you need an API key. You can get this key from your account manager at Trustpilot. Here's an article about [getting started with our APIs](https://support.trustpilot.com/hc/articles/207309867).

API documentation can be found at [developers.trustpilot.com](https://developers.trustpilot.com/)
