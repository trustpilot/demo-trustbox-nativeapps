package com.trustpilot.trustboxinnativeapp;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;

public class TrustBoxFragment extends Fragment {
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_trustbox, container, false);
        return rootView;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        String bootstrap = "<!-- TrustBox script --> <script type=\"text/javascript\" src=\"https://widget.trustpilot.com/bootstrap/v5/tp.widget.bootstrap.min.js\" async></script> <!-- End Trustbox script -->";
        String trustBox = "<!-- TrustBox widget - Mini Carousel --> <div class=\"trustpilot-widget\" data-locale=\"en-US\" data-template-id=\"539ad0ffdec7e10e686debd7\" data-businessunit-id=\"46d6a890000064000500e0c3\" data-style-height=\"350px\" data-style-width=\"100%\" data-theme=\"light\" data-stars=\"1,2,3,4,5\"> <a href=\"https://www.trustpilot.com/review/revelsystems.com\" target=\"_blank\">Trustpilot</a> </div> <!-- End TrustBox widget -->";

        WebView webView = (WebView)this.getActivity().findViewById(R.id.trustbox_view);
        webView.getSettings().setJavaScriptEnabled(true);
        webView.loadDataWithBaseURL(
                "https://widget.trustpilot.com",
                bootstrap + trustBox,
                "text/html",
                null,
                null);

    }
}
