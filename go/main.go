package main

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/pmlogist/blog/api/db"
)

type SongResponse struct {
	ID  int64  `json:"id"`
	Src string `json:"src"`
}

func songHandler(w http.ResponseWriter, r *http.Request) {
	songs := []db.Song{
		{ID: 1, Src: "/music/audio2.mp3"},
	}

	var response []SongResponse

	for _, v := range songs {
		response = append(response, SongResponse{
			ID:  v.ID,
			Src: v.Src,
		})
	}

	j := json.NewEncoder(w)

	err := j.Encode(&response)
	if err != nil {
		fmt.Print(err)
	}
}

func main() {

	mux := http.NewServeMux()

	mux.HandleFunc("/", songHandler)

	http.ListenAndServe(":3000", mux)

}
