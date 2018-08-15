# 手動カメラ

![](./screenshots/appicon.jpg)

AVFoundationを使用した修作カメラアプリです。iPhone用のカメラアプリ開発の方法を理解するためにAVFoundation APIの多くを使用しています。

ソースコードの整理・設計の見直し・UIの調整を行う余地を多く含んでいますが、なんとか形になったのでプロジェクトを公開しました。このプロジェクトは自分が使用するアプリが欲しくて行なったDIYプロジェクトです。

商用かどうかに関わらずソースコードはいかなる形態で利用しても構いませんが、機能の改善・追加・操作性の向上を行なった場合はフィードバックをいただけると嬉しいです。良いカメラアプリができましたら是非おしらせください。

以下、主な機能を解説します。

### ズームイン・アウト

画面をピンチ操作することでズームの調整ができます。１倍から６倍の間で調整できるようにしています。

![](./screenshots/pinch_zoom.PNG)

### タップフォーカス

画面をタップ操作することで焦点を合わせます。この機能はフォーカスモードが「AF」の時のみ使用できます。

![](./screenshots/tap_focus.PNG)

### フォーカスモード

AF（オートフォーカス）とMF（マニュアルフォーカス）の切り替えと、マニュアルフォーカス時の焦点距離の調整を行う機能です。

![](./screenshots/focus_mode.PNG)

### シャッタースピード

シャッタースピードを調整する機能です。自動シャッタースピードを選択する場合はスイッチをオフにします。

![](./screenshots/shutter_speed.PNG)

### ISO感度

ISO感度を調整する機能です。自動ISO感度を選択する場合はスイッチをオフにします。

![](./screenshots/iso.PNG)

### 露出

露出を調整する機能です。自動露出を選択する場合はスイッチをオフにします。

![](./screenshots/exposure.png)

### ホワイトバランス

ホワイトバランスを調整する機能です。オート、白熱灯、蛍光灯、夕方・朝方、フラッシュ使用、晴天、曇天、日陰の中から選択できます。

![](./screenshots/wb.PNG)

### フラッシュモード

フラッシュのモードをオン、オフ、自動の中から選択する機能です。

![](./screenshots/flash_mode.PNG)

### セルフタイマーモード

セルフタイマーのモードをオフ、２秒、５秒、１０秒の中から選択する機能です。

![](./screenshots/selftimer.PNG)

### タイムラプスモード

一定間隔で複数枚の写真を撮影する機能です。枚数（Count）と撮影間隔（Interval）を設定します。

![](./screenshots/timelapse.PNG)



----
[ブログ](https://tsubakicraft.wordpress.com)にも色々書いていますので、お時間がありましたら覗いてください。

[椿工藝舎のホームページ](http://tsubakicraft.jp)

椿工藝舎はオリジナルのギターや革製品を製作している工房です。
