//@flow
function forceDownload(blob, filename) {
  let a = document.createElement('a');
  a.download = filename;
  a.href = blob;
  a.click();
}

// Current blob size limit is around 500MB for browsers
export function downloadResource(url: any, filename: any) {
  if (!filename)
    filename = url
      .split('\\')
      .pop()
      .split('/')
      .pop();
  fetch(url)
    .then(response => response.blob())
    .then(blob => {
      let blobUrl = window.URL.createObjectURL(blob);
      forceDownload(blobUrl, filename);
    })
    .catch(e => console.error(e));
}
