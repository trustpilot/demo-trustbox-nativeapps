# Using TrustBoxes in native apps

This repository has an  iOS and an Android app that show how Trustpilot's TrustBoxes can be used in a native app. There are examples of using the TrustBoxes for web and building a custom integration with the Trustpilot API.

## Using a TrustBox

The TrustBoxes are designed to be used on web sites and the implementation is therefore based on copy/pasting an HTML `<script>` tag that loads the TrustBox functionality and a `<div>` that defines the parameters of the specific TrustBox. But they can be used fairly easily in a native mobile app by using the platforms' web view controls.

See guides and specific implementation details in the sub folders here:

- [iOS app](https://github.com/trustpilot/demo-trustbox-nativeapps/tree/master/iOS)
- [Android app](https://github.com/trustpilot/demo-trustbox-nativeapps/tree/master/Android)

The TrustBoxes can be found in our business product.


## Using our API

We have a public API that can be used to build custom versions of the TrustBoxes. Essentially the TrustBoxes are built on these APIs. Through the APIs you can get details about a company on Trustpilot such as their TrustScore, number of reviews and current star rating. You can also request reviews that can then be displayed in your app.

To use our APIs you need an API key. You can get this key from your account manager at Trustpilot. Here's an article about [getting started with our APIs](https://support.trustpilot.com/hc/articles/207309867).

API documentation can be found at [developers.trustpilot.com](https://developers.trustpilot.com/)

The two demo apps in the repository are using are API to show a company's stars etc. See the specific implementations here:

- [iOS app](https://github.com/trustpilot/demo-trustbox-nativeapps/tree/master/iOS)
- [Android app](https://github.com/trustpilot/demo-trustbox-nativeapps/tree/master/Android)
