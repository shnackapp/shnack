function changeImage()
{
    var img = document.getElementById("slideshow");
    img.src = images[x];
    x++;

    if(x >= images.length){
        x = 0;
    } 

    setTimeout("changeImage()", 3000);
}


var images = [],
x = 0;

images[0] = "images/bg1.jpg";
images[1] = "images/bg2.jpg";
images[2] = "images/bg3.jpg";
setTimeout("changeImage()", 3000);