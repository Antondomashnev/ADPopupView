ADPopupView
=============
-------------

ADPopupView is an iOS drop-in classes that displays popup at custom point in custom view. It automatically drawing itself according current position and parent view bounds. ADPopupView providing some cusotmization mechanism and support two type: popup with text or popup with custom view.

[![](https://dl.dropbox.com/u/25847340/ADPopupView/screenshot1-thumb.png)](https://dl.dropbox.com/u/25847340/ADPopupView/screenshot1.png)
[![](https://dl.dropbox.com/u/25847340/ADPopupView/screenshot2-thumb.png)](https://dl.dropbox.com/u/25847340/ADPopupView/screenshot2.png)
[![](https://dl.dropbox.com/u/25847340/ADPopupView/screenshot3-thumb.png)](https://dl.dropbox.com/u/25847340/ADPopupView/screenshot3.png)
[![](https://dl.dropbox.com/u/25847340/ADPopupView/screenshot4-thumb.png)](https://dl.dropbox.com/u/25847340/ADPopupView/screenshot4.png)

------------
Requirements
============

ADPopupView works on any iOS version only greater or equal than 4.3 and is compatible with only ARC projects. It depends on the following Apple frameworks, which should already be included with most Xcode templates:

* Foundation.framework
* UIKit.framework
* CoreGraphics.framework

You will need LLVM 3.0 or later in order to build ADPopupView.

------------------------------------
Adding ADPopupView to your project
====================================

Source files
------------

The simplest way to add the ADPopupView to your project is to directly add the source files and resources to your project.

1. Download the [latest code version](https://github.com/Antondomashnev/ADPopupView/downloads) or add the repository as a git submodule to your git-tracked project. 
2. Open your project in Xcode, than drag and drop ADPopupView.h and ADPopupView.m from Source directory onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project. 
3. Include ADPopupView wherever you need it with `#import "ADPopupView.h"`.

-----
Usage
=====

In ADPopupView project there is a demo UIViewController (as ViewController.m) which show a simple usage example. Just touch on simulator screen and ADPopupView will be shown at touch position.

-------
License
=======

This code is distributed under the terms and conditions of the MIT license. 

----------
Change-log
==========

**Version 1.0** @ 28.2.13

- Initial release.


