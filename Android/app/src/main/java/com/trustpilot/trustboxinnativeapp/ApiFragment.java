package com.trustpilot.trustboxinnativeapp;

import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.content.res.ResourcesCompat;
import android.support.v7.view.ContextThemeWrapper;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.style.StyleSpan;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.android.volley.Cache;
import com.android.volley.Network;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.BasicNetwork;
import com.android.volley.toolbox.DiskBasedCache;
import com.android.volley.toolbox.HurlStack;
import com.android.volley.toolbox.JsonObjectRequest;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;


public class ApiFragment extends Fragment {
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_api, container, false);
        return rootView;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        setSummaryViews(0, 0, 0);

        final ApiFragment self = this;

        JsonObjectRequest apiRequest = new JsonObjectRequest(Request.Method.GET, "https://api.trustpilot.com/v1/business-units/46d6a890000064000500e0c3/", null,
        new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject response) {
                try {
                    int stars = response.getInt("stars");
                    double score = response.getDouble("trustScore");

                    JSONObject reviews = response.getJSONObject("numberOfReviews");
                    int total = reviews.getInt("total");

                    self.setSummaryViews(stars, score, total);
                }
                catch(JSONException exception) {
                    Log.e("API ", "Error when parsing JSON", exception);
                }

                Log.v("API", response.toString());
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Log.e("API", "Error loading JSON", error);
            }
        }) {
            public Map<String,String> getHeaders() {
                Map<String, String>  params = new HashMap<>();
                params.put("ApiKey", "YOU_API_KEY"); // TODO Get an API key from an account manager and paste it here.

                return params;
            }
        };


        Cache cache = new DiskBasedCache(this.getContext().getCacheDir(), 0);
        Network network = new BasicNetwork(new HurlStack());
        RequestQueue queue = new RequestQueue(cache, network);
        queue.start();
        queue.add(apiRequest);
    }

    private void setSummaryViews(int stars, double trustScore, int numberOfReviews) {
        int starStyle = 0;
        switch (stars) {
            case 1:
                starStyle = R.style.Stars1;
                break;
            case 2:
                starStyle = R.style.Stars2;
                break;
            case 3:
                starStyle = R.style.Stars3;
                break;
            case 4:
                starStyle = R.style.Stars4;
                break;
            case 5:
                starStyle = R.style.Stars5;
                break;
        }

        ImageView imageView = (ImageView)this.getActivity().findViewById(R.id.starsImageView);
        final ContextThemeWrapper wrapper = new ContextThemeWrapper(this.getActivity(), starStyle);
        final Drawable drawable = ResourcesCompat.getDrawable(getResources(), R.drawable.stars, wrapper.getTheme());
        imageView.setImageDrawable(drawable);

        SpannableString trustScoreString = new SpannableString(String.valueOf(trustScore));
        Log.d("trustScoreText", trustScoreString.toString() + " "  + trustScoreString.length());
        trustScoreString.setSpan(new StyleSpan(Typeface.BOLD), 0, trustScoreString.length(), Spanned.SPAN_INCLUSIVE_INCLUSIVE);

        SpannableString reviewsString = new SpannableString(String.valueOf(numberOfReviews));
        reviewsString.setSpan(new StyleSpan(Typeface.BOLD), 0, reviewsString.length(), Spanned.SPAN_INCLUSIVE_INCLUSIVE);

        TextView trustScoreView = (TextView)this.getActivity().findViewById(R.id.trustScoreView);
        trustScoreView.setText(TextUtils.concat("TRUSTSCORE ",
                 trustScoreString,
                "  |  ",
                reviewsString,
                " REVIEWS"));
    }
}
