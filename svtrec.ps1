Param(
    [ValidateScript({$_.AbsoluteURI -ne $null -and $_.Scheme -match '[http|https]'})]
    [System.URI]
    $url
  ,
    [string]
    $outputFile = "video.mp4"
)

$url.AbsoluteUri -match '(?<=\/video\/)\d+'
$jsonUrl = "http://www.svtplay.se/video/" + $matches[0] + "?output=json"
$videoUrl = ((Invoke-RestMethod $jsonUrl).video.videoReferences | Where-Object { $_.playerType -eq "ios" } | Select-Object -first 1).url -replace "master.m3u8.*", "index_6_av.m3u8"
ffmpeg -i "$videoUrl"  -acodec copy -vcodec copy -absf aac_adtstoasc $outputFile