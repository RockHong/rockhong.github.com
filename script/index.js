// sometimes, douban fails to return images
function dbImageFailOver() {
    this.src = "../images/db-pic-load-error-66-98.png";
}

var dbImages = document.querySelectorAll("#db-collect img");
for (var i = 0; i < dbImages.length; ++i) {
    dbImages[i].onerror = dbImageFailOver;
}
