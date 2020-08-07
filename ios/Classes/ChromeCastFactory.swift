//
//  ChromeCastFactory.swift
//  flutter_video_cast
//
//  Created by Alessio Valentini on 07/08/2020.
//

import Flutter

public class ChromeCastFactory: NSObject, FlutterPlatformViewFactory {
    let registrar: FlutterPluginRegistrar

    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
    }

    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return ChromeCastController(withFrame: frame, viewIdentifier: viewId, arguments: args, registrar: registrar)
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
