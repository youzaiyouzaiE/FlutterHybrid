
Flutter混合开发实践

目录
一. 回顾和补充
1. 架构
2. Embedder 嵌入层
3. Isolate
二.  在Flutter项目中加入原生
1.概念
三.  iOS原生项目加入Flutter
1.生成Flutter组件
2. 将Flutter 加入到原生项目, 原生项目依赖Flutter
3. 在iOS项目中使用Flutter的热加载
4. 发生了什么
四. UI交互
1. UI交互演示
五. 数据交互
1.概念
2. 具体实现
3. 原理
4. 演示例子
六. Flutter Boost
1.为什么有Flutter Boost
2.  Flutter Boost演示
七. Flutter桌面程序
以下分享内容都已经在demo中实现, 欢迎下载.  传送门

一. 回顾和补充
1. 架构

Framework使用dart实现，包括Material Design风格的Widget,Cupertino(针对iOS)风格的Widgets，文本/图片/按钮等基础Widgets，渲染，动画，手势等。此部分的核心代码是:flutter仓库下的flutter package，以及sky_engine仓库下的io, async, ui(dart:ui库提供了Flutter框架和引擎之间的接口)等package。

Engine使用C++实现，主要包括:Skia, Dart和Text。Skia是开源的二维图形库，提供了适用于多种软硬件平台的通用API。其已作为Google Chrome，Chrome OS，Android, Mozilla Firefox, Firefox OS等其他众多产品的图形引擎，支持平台还包括Windows7+,macOS 10.10.5+,iOS8+,Android4.1+,Ubuntu14.04+等。Dart部分主要包括:Dart Runtime，Garbage Collection(GC)，如果是Debug模式的话，还包括JIT(Just In Time)支持。Release和Profile模式下，是AOT(Ahead Of Time)编译成了原生的arm代码，并不存在JIT部分。Text即文本渲染，其渲染层次如下:衍生自minikin的libtxt库(用于字体选择，分隔行)。HartBuzz用于字形选择和成型。Skia作为渲染/GPU后端，在Android和Fuchsia上使用FreeType渲染，在iOS上使用CoreGraphics来渲染字体。

Embedder是一个嵌入层，即把Flutter嵌入到各个平台上去，这里做的主要工作包括渲染Surface设置, 线程设置, 以及插件等。从这里可以看出，Flutter的平台相关层很低，平台(如iOS)只是提供一个画布，剩余的所有渲染相关的逻辑都在Flutter内部，这就使得它具有了很好的跨端一致性。

2. Embedder 嵌入层
Embedder中存在四个Runner，四个Runner分别如下。Runner是一个抽象概念，我们可以往Runner里面提交任务，任务被Runner放到它所在的线程去执行. 非常类似于iOS的Runloop, 有活就干, 没活就释放资源等着.  其中每个Flutter Engine各自对应一个UI Runner、GPU Runner、IO Runner，但所有Engine共享一个Platform Runner。

Platform Runner和iOS平台的Main Thread非常相似，在Flutter中除耗时操作外，所有任务都应该放在Platform中. 

UI Runner负责为Flutter Engine执行Root Isolate的代码. 

GPU Runner并不直接负责渲染操作，其负责GPU相关的管理和调度。

一些GPU Runner中比较耗时的操作，就放在IO Runner中进行处理，例如图片读取、解压、渲染等操作。


3. Isolate
Futter Framework使用Dart语言开发，所以App进程中需要一个Dart运行环境（VM），和Android Art一样，Flutter也对Dart源码做了AOT编译，直接将Dart源码编译成了本地字节码，没有了解释执行的过程，提升执行性能。来看下Dart VM内存分配(Allocate)和回收(GC)相关的部分。

一个进程里面最多只会初始化一个Dart VM。然而一个进程可以有多个Flutter Engine，多个Engine实例共享同一个Dart VM。

和Java显著不同的是Dart的"线程"(Isolate)是不共享内存的，各自的堆(Heap)和栈(Stack)都是隔离的，并且是各自独立GC的，彼此之间通过消息通道来通信。Dart天然不存在数据竞争和变量状态同步的问题，整个Flutter Framework Widget的渲染过程都运行在一个isolate中。


DartVM VS Dalvik: https://gudong.name/2017/04/14/jvm_vs_dalvik.html

二.  在Flutter项目中加入原生

1.概念
我们使用flutter create xxx可以创建一个Flutter项目, 这个项目包括一个Android App和一个iOS App,  我们可以分别在这两个App中使用原生语言来开发我们的需求. 

Flutter projects created using flutter create xxx include very simple host apps for your Flutter/Dart code (a single-Activity Android host and a single-ViewController iOS host). You can modify these host apps to suit your needs and build from there.


跳过该部分

三.  iOS原生项目加入Flutter
链接
闲鱼研究: https://www.infoq.cn/article/VBqfCIuwdjtU_CmcKaEu

官方方案: https://github.com/flutter/flutter/wiki/Add-Flutter-to-existing-apps

官方更新: https://github.com/flutter/flutter/projects/28

非常简易的将Flutter加入到现有的APP中的这些工作, FlutterRD还一直在处理中, 以下这些方法更新与2019年7月31日(刚刚更新, 上次更新是2018年5月份).  目前还是个Beta版本, 不是非常稳定, 随时都可能变化. 亲测好用. 

1.生成Flutter组件
如果我们的现有APP是原生APP, 当我们想在原生APP的基础上加入Flutter代码时, 我们可以使用Flutter的组件模板. 在特定的目录下使用终端执行 flutter create -t module xxx 会生成一个生成一个带有安卓库和iOS Pod的Flutter项目. 

But if you're starting off with an existing host app for either platform, you'll likely want to include your Flutter project in that app as some form of library instead.

This is what the Flutter module template provides. Executing flutter create -t module xxx produces a Flutter project containing an Android library and a CocoaPods pod designed for consumption by your existing host app

生成目录: 


2. 将Flutter 加入到原生项目, 原生项目依赖Flutter
集成Flutter我们需要CocoaPods来管理依赖. 这是因为Flutter Framework 需要对包含与my_flutter的所有Flutter组件都要有效. 

Integrating the Flutter framework requires use of the CocoaPods dependency manager. This is because the Flutter framework needs to be available also to any Flutter plugins that you might include in my_flutter.

修改podfile

代码块
Python
platform :ios, '9.0'
​
flutter_application_path = '/Users/gaodeying/Desktop/Git_FlutterHybrid/flutter_to_native/'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')
​
target 'iOSWithFlutterSingleVC' do
​
   install_all_flutter_pods(flutter_application_path)
   pod 'AFNetworking'
    
end
​
Flutter.framework (the Engine library) 被嵌入到原生APP中:   CocoaPods 拉取Engine library作为一个静态库并且将其嵌入到原生APP中. 

App.framework (Flutter application binary) 被嵌入到原生APP中:  CocoaPods 拉取Flutter application作为一个静态库并且将其嵌入到原生APP中. 

修改Bitcode

Build Settings->Build Options->Enable Bitcode setting to No.

纯iOS项目与混合项目的运行内存比较. 

3. 在iOS项目中使用Flutter的热加载
链接真机或模拟器

代码块
Python
gaodeyingdeMacBook-Pro-2:flutter_to_native gaodeying$ flutter attach
Checking for advertised Dart observatories...
Waiting for a connection from Flutter on iPhone Xʀ...
链接

在debug下运行iOS原生项目

代码块
Python
gaodeyingdeMacBook-Pro-2:flutter_to_native gaodeying$ flutter attach
Checking for advertised Dart observatories...
Waiting for a connection from Flutter on iPhone Xʀ...
Done.
Syncing files to device iPhone Xʀ...                             1,753ms
​
🔥  To hot reload changes while running, press "r". To hot restart (and rebuild state), press "R".
An Observatory debugger and profiler on iPhone Xʀ is available at: http://127.0.0.1:52036/oLuPiCIHciw=/
For a more detailed help message, press "h". To detach, press "d"; to quit, press "q".
​
演示链接成功. 演示必须得SingleViewController方式创建项目. 

4. 发生了什么
Flutter.framework (the Engine library) is getting embedded into your app for you. This has to match up with the release type (debug/profile/release) as well as the architecture for your app (arm*, i386, x86_64, etc.). CocoaPods pulls this in as a vendored framework and makes sure it gets embedded into your native app.

Flutter.framework被嵌入到我们到原生项目中, Flutter.framework中包含了Flutter的Engine. 注意一点: Flutter.framework必须跟我们项目的发布方式和项目结构相匹配. 这整个过程是CocoaPods帮我们把Flutter Engine作为一个Framework嵌入到原生工程中. 

App.framework (your Flutter application binary) is embedded into your app. CocoaPods also pulls this in as a vendored framework and makes sure it gets embedded into your native app.

App.framewrok也被嵌入到我们到原生项目中, App.framework中包含了Flutter项目的二进制文件. 这整个过程也是CocoaPods帮我们把Flutter工程文件作为一个Framework嵌入到原生工程中. 

Any plugins are added as CocoaPod pods. In theory, it should be possible to manually merge those in as well, but those instructions vary on the pod dependencies of each plugin.

Flutter中的每一个插件都会作为一个pod被嵌入到原生项目中. 

A build script is added to the Podfile targets that call install_all_flutter_pods to ensure that the binaries you build stay up to date with the Dart code that's actually in the folder. It also uses your Xcode build configuration (Debug, Profile, Release) to embed the matching release type of Flutter.framework and App.framework.

Podfile中的脚本使原生项目中的Flutter二进制文件与Flutter Module中的代码保持一致. 

四. UI交互
1. UI交互演示
我们已经将Flutter中加入到我们的工程项目中, 那么我们现在就可以在原生项目中使用Flutter了. 

原生Page Push进入Flutter.


Flutter Push进入原生Page.


使用消息通道来做. 

Flutter Page加载原生元素.


原生Page加载Flutter元素. 


五. 数据交互
链接
原文: https://flutter.dev/docs/development/platform-integration/platform-channels

闲鱼的使用:  https://www.yuque.com/xytech/flutter/agwvd2

闲鱼对channel的原理研究: https://www.jianshu.com/p/39575a90e820

官方示例: https://github.com/flutter/flutter/tree/master/examples/platform_channel

案例: https://github.com/wang709693972wei/flutter_module

1.概念
架构概览

Flutter uses a flexible system that allows you to call platform-specific APIs whether available in Java or Kotlin code on Android, or in Objective-C or Swift code on iOS.

我们可以在使用Java或Kotlin开发的安卓项目中使用Flutter来调用原生的API. 同样, 我们也可以在使用OC或Swift开发的苹果项目中使用Flutter来调用原生的API. 


消息和响应是异步传递的，以确保用户界面保持响应性。

标准平台通道使用标准消息编解码器，以支持简单的类似JSON值的高效二进制序列化，例如 booleans,numbers, Strings, byte buffers, List, Maps.  当发送和接收值时，这些值在消息中的序列化和反序列化会自动进行。

2. 具体实现
Flutter定义了三种不同类型的Channel，它们分别是:

BasicMessageChannel：用于传递字符串和半结构化的信息.

MethodChannel：用于传递方法调用（method invocation）。

EventChannel: 用于数据流（event streams）的通信

三种Channel之间互相独立，各有用途，但它们在设计上却非常相近。每种Channel均有三个重要成员变量：

name: String类型，代表Channel的名字，也是其唯一标识符。

messager：BinaryMessenger类型，代表消息信使，是消息的发送与接收的工具。

codec: MessageCodec类型或MethodCodec类型，代表消息的编解码器。

3. 原理
BinaryMessenger是Platform端与Flutter端通信的工具，其通信使用的消息格式为二进制格式数据。当我们初始化一个Channel，并向该Channel注册处理消息的Handler时，实际上会生成一个与之对应的BinaryMessageHandler，并以channel name为key，注册到BinaryMessenger中。当Flutter端发送消息到BinaryMessenger时，BinaryMessenger会根据其入参channel找到对应的BinaryMessageHandler，并交由其处理。

 Binarymessenger在Android端是一个接口，其具体实现为FlutterNativeView。而其在iOS端是一个协议，名称为FlutterBinaryMessenger，FlutterViewController遵循了它。

 Binarymessenger并不知道Channel的存在，它只和BinaryMessageHandler打交道。而Channel和BinaryMessageHandler则是一一对应的。由于Channel从BinaryMessageHandler接收到的消息是二进制格式数据，无法直接使用，故Channel会将该二进制消息通过Codec（消息编解码器）解码为能识别的消息并传递给Handler进行处理。

当Handler处理完消息之后，会通过回调函数返回result，并将result通过编解码器编码为二进制格式数据，通过BinaryMessenger发送回Flutter端。


4. 演示例子
消息通道

方法通道

事件通道

六. Flutter Boost
flutter boost地址: https://github.com/alibaba/flutter_boost

1.为什么有Flutter Boost
具有一定规模的App通常有一套成熟通用的基础库，一般需要依赖很多体系内的基础库。那么使用Flutter重新从头开发App的成本和风险都较高。所以在Native App进行渐进式迁移是Flutter技术在现有Native App进行应用的稳健型方式

每初始化一个FlutterViewController就会有一个引擎随之初始化，也就意味着会有新的线程（理论上线程可以复用）去跑Dart代码。

所以在混合方案中解决的主要问题是如何去处理交替出现的Flutter和Native页面。Flutter的官方给出的是Keep It Simple的方案：对于连续的Flutter页面（Widget）只需要在当前FlutterViewController打开即可，对于间隔的Flutter页面我们初始化新的引擎。

Flutter Page1 -> Flutter Page2 -> Native Page1 -> Flutter Page3

那么官方方案存在以下几个问题: 

a. 冗余的资源问题.多引擎模式下每个引擎之间的Isolate是相互独立的。在逻辑上这并没有什么坏处，但是引擎底层其实是维护了图片缓存等比较消耗内存的对象。

b. 插件注册的问题。插件依赖Messenger去传递消息，而目前Messenger是由FlutterViewController（Activity）去实现的。如果你有多个FlutterViewController，插件的注册和通信将会变得混乱难以维护，消息的传递的源头和目标也变得不可控。

c. Flutter Widget和Native的页面差异化问题。Flutter的页面是Widget，Native的页面是VC。逻辑上来说我们希望消除Flutter页面与Naitve页面的差异，否则在进行页面埋点和其它一些统一操作的时候都会遇到额外的复杂度。

d. 增加页面之间通信的复杂度。如果所有Dart代码都运行在同一个引擎实例，它们共享一个Isolate，可以用统一的编程框架进行Widget之间的通信，多引擎实例也让这件事情更加复杂。

2.  Flutter Boost演示
七. Flutter桌面程序
flutter支持的平台

仅供内部使用，未经授权，切勿外传
0 人赞了它
浏览 64 次 共 4 人浏览
评论(0)

写点你要说的
目录
目录
一. 回顾和补充
1. 架构
2. Embedder 嵌入层
3. Isolate
二. 在Flutter项目中加入原生
1.概念
三. iOS原生项目加入Flutter
1.生成Flutter组件
2. 将Flutter 加入到原生项目, 原生项目依赖Flutter
3. 在iOS项目中使用Flutter的热加载
4. 发生了什么
四. UI交互
1. UI交互演示
五. 数据交互
1.概念
2. 具体实现
3. 原理
4. 演示例子
六. Flutter Boost
1.为什么有Flutter Boost
2. Flutter Boost演示
七. Flutter桌面程序
