# ($1:appFileName, $2:imageFilePath):
function addImageToQueue {
  open -g -a $1 "$2"
}

# ($1:fileTypes, $2:appFileName): Queue direcory of images
function addDirectoryToQueue {
  find -E "$imgPath" -regex $1 -print0 | while IFS= read -r -d $'\0' img; do
    addImageToQueue $2 "$img"
  done
}

# ($1:appShouldBeRun, $2:appName, $3:fileTypes, $4:appFileName):
function runPornelAppOnDirectory {
  if [ "true" == $1 ]; then
    addDirectoryToQueue $3 $4
    waitForApp $2
    if [ "true" == $quitOnComplete ]; then
      osascript -e "tell application \"$2\" to quit"
    fi
  fi
}

# ():
function runImageOptimOnDirectory {
  runPornelAppOnDirectory $useImageOptim $imageOptimAppName $imageOptimFileTypes $imageOptimAppFileName
}

# ():
function runImageAlphaOnDirectory {
  runPornelAppOnDirectory $useImageAlpha $imageAlphaAppName $imageAlphaFileTypes $imageAlphaAppFileName
}

# ($1:appShouldBeRun, $2:appName, $3:fileTypes, $4:appFileName, $5:image):
function runPornelAppOnImage {
  if [ "true" == $1 ]; then
    addImageToQueue $4 "$5"
    waitForApp $2
    if [ "true" == $quitOnComplete ]; then
      osascript -e "tell application \"$2\" to quit"
    fi
  fi
}

# ($1:image):
function runImageOptimOnImage {
  runPornelAppOnImage $useImageOptim $imageOptimAppName $imageOptimFileTypes $imageOptimAppFileName "$1"
}

# ($1:image):
function runImageAlphaOnImage {
  runPornelAppOnImage $useImageAlpha $imageAlphaAppName $imageAlphaFileTypes $imageAlphaAppFileName "$1"
}

# ($1:path):
function runJPEGmini {
  if [ "true" == $useJPEGmini ]; then
    `osascript "$cliPath/imageOptimAppleScriptLib" run_jpegmini "$1" $jpegMiniAppName` > /dev/null 2>&1
    sleep 1
    `osascript "$cliPath/imageOptimAppleScriptLib" wait_for $jpegMiniAppName` > /dev/null 2>&1
    if [ "true" == $quitOnComplete ]; then
      osascript -e "tell application \"$jpegMiniAppName\" to quit"
    fi
  fi
}