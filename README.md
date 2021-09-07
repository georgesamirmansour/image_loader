# image_loader

Image loader is a helper library to load image from many resources as[assets, file or cache Network image].
  With support with making shape around it as circle or rounded corners

<img src="https://github.com/georgesamirmansour/image_loader/blob/master/screenShot/1.png?raw=true" width="250" height="500">
<img src="https://github.com/georgesamirmansour/image_loader/blob/master/screenShot/2.png?raw=true" width="250" height="500">



## Getting Started



## Examples: ImageHelper
```groovy
ImageHelper(
              image: networkImageUrl,
              // image scale
              scale: 1.0,
              // Quality levels for image sampling in [ImageFilter] and [Shader] objects that sample
              filterQuality: FilterQuality.high,
              // border radius only work with [ImageShape.rounded]
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              // alignment of image
              alignment: Alignment.center,
              // indicates where image will be loaded from, types are [network, asset,file, svg, networkSvg]
              imageType: ImageType.network,
              // indicates what shape you would like to be with image [rectangle, oval,circle or none]
              imageShape: ImageShape.rectangle,
              // image default box fit
              boxFit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // imagePath: 'assets/images/image.png',
              // default loader color, default value is null
              defaultLoaderColor: Colors.red,
              // default error builder color, default value is null
              defaultErrorBuilderColor: Colors.blueGrey,
              // the color you want to change image with
              color: Colors.blue,
              // blend mode with image only
              blendMode: BlendMode.srcIn,
              // error builder widget, default as icon if null
              errorBuilder: _errorBuilderIcon,
              // loader builder widget, default as icon if null
              loaderBuilder: _loader,
            )
```
License
--------
MIT License

Copyright (c) 2021 George Samir

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.