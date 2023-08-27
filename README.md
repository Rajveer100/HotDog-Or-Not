# About
iOS App utilising CoreML and Vision to classify image as a HotDog 🌭 or Not ❌. Inspired by Silicon Valley ;)

# Description
The app uses the `InceptionV3` model to distinguish across 1000+ categories of images `pre-trained` and can detect common
objects in the real world to a good accuracy (depends on the image attributes like crop, zoom, focus on target image, etc).

The images are converted via `CoreML` and `Vision` frameworks in `iOS` to `CIImage` by trying to request the `model` object 
and detect the results with their `confidence` magnitudes.

# Demo

The app will required `permission` to access the camera / photo library as a `prompt` to test on a `physical device`. 

Here's a brief visual:

<img src="Resources/HotDog-Gif.gif" />
<img src="Resources/Not-HotDog-Gif.gif" />
