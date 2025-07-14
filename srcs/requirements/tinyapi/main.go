package main

import (
	"encoding/json"
	"io"
	"net/http"
	"os"
	"time"
)

type Response struct {
	Time     string `json:"time,omitempty"`
	Hostname string `json:"hostname,omitempty"`
	Weather  string `json:"weather,omitempty"`
}

func getWeather() string {
	resp, err := http.Get("https://wttr.in/Berlin?format=1")
	if err != nil {
		return "unavailable"
	}
	defer resp.Body.Close()
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "unavailable"
	}
	return string(body)
}

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		resp := Response{}
		q := r.URL.Query()
		if _, ok := q["time"]; ok {
			resp.Time = time.Now().Format(time.RFC3339)
		}
		if _, ok := q["hostname"]; ok {
			hostname, _ := os.Hostname()
			resp.Hostname = hostname
		}
		if _, ok := q["weather"]; ok {
			resp.Weather = getWeather()
		}
		// If no query params, return all
		if len(q) == 0 {
			resp.Time = time.Now().Format(time.RFC3339)
			hostname, _ := os.Hostname()
			resp.Hostname = hostname
			resp.Weather = getWeather()
		}
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(resp)
	})
	http.ListenAndServe(":8080", nil)
}
