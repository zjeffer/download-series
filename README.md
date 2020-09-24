# downloadSeries.sh

* Requires [youtube-dl](https://github.com/ytdl-org/youtube-dl) and `ffmpeg`

Download episodes from a streaming site using their DASH manifest links. Works with all links compatible with youtube-dl.

```
Usage: downloadSeries.sh [-p ARGS] [-f FILE] [-d DIRECTORY]

-p  (optional) Add ffmpeg's --postprocessor-args arguments to every youtube-dl command

-f  (required) File with DASH manifest links and episode numbers:
    Every line in the <FILE> should have the following format: \"MPDLINK SxxExx\",
    where MPDLINK is a link to the .mpd file, and SxxExx is the season and episode.
-d  (optional) Directory to save the episodes in.
    Default is current directory (./)
```

example file: `episodes.txt`

```
https://example.com/serieName/link/to/episode/link.mpd S01E01
https://example.com/serieName/link/to/episode/link.mpd S01E02
https://example.com/serieName/link/to/episode/link.mpd S01E03
```

example syntax to download episode S01E01-S01E03 and put it in the "serieName" folder.

`./downloadSeries -f episodes.txt -d "serieName"`

# cutAds.sh

* Requires `ffmpeg`, `ffprobe`
* Requires the `nvidia-codec` and `cuda` packages to use hardware accelerated encoding (if using Nvidia)

If a downloaded video has ads at the beginning and/or end of it, this cuts them out.

```
Usage: cutAds.sh [-d DIRECTORY] [-f FILE] [-s START] [-e END]

-d  directory of .mp4 files

-f  or just one mp4 file

-s  cut out this amount of seconds at the start

-e  cut out this amount of seconds at the end
```




