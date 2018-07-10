//
//  WebServiceController.swift
//  verzity
//
//  Created by Jossue Betancourt on 21/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class WebServiceController: AlamofireWebServiceController{
    
    // CanjearCupon
    func CanjearCupon(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.CanjearCupon)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    // GetDetalleNotificacion
    func GetDetalleNotificacion(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.GetDetalleNotificacion)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    // ConsultarNotificaciones
    func ConsultarNotificaciones(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.ConsultarNotificaciones)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    // GetPostulados
    func GetPostulados(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.GetPostulados)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    
    // RegistrarUniversidad
    func RegistrarUniversidad(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.RegistrarUniversidad)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    // GetFavoritos
    func GetFavoritos(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.GetFavoritos)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    
    // SetFavorito
    func SetFavorito(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.SetFavorito)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    
    // PostularseBeca
    func PostularseBeca(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.PostularseBeca)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    // GetVideos
    func GetVideos(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.GetVideos)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    // GetProgramasAcademicos
    func GetProgramasAcademicos(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.GetProgramasAcademicos)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    // 2.12 RegistrarVisitaBanners
    func RegistrarVisitaBanners(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.RegistrarVisitaBanners)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    
    // GetBannersVigentes
    func GetBannersVigentes(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.GetBannersVigentes)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    
    // GetDetallesUniversidad
    func GetDetallesUniversidad(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.GetDetallesUniversidad)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    
    // BusquedaUniversidades
    func BusquedaUniversidades(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.BusquedaUniversidades)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    
    // IngresarUniversitario
    /*
    func IngresarUniversitario(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.IngresarUniversitario)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }*/
    
    
    // IngresarAppUniversidad
    func IngresarAppUniversidad(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.IngresarAppUniversidad)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    // CrearCuentaAcceso
    func CrearCuentaAcceso(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.CrearCuentaAcceso)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    // GetFinanciamientosVigentes
    func GetFinanciamientosVigentes(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.GetFinanciamientosVigentes)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    // SolicitarFinanciamientos
    func SolicitarFinanciamientos(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.SolicitarFinanciamientos)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    
    //IngresarAppUniversitario
    func IngresarAppUniversitario(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.IngresarAppUniversitario)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    //GetDetalleCupon
    func GetDetalleCupon(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.GetDetalleCupon)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    
    // GetCuponesVigentes
    func GetCuponesVigentes(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.GetCuponesVigentes)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    
    // GetBecasVigentes
    func GetBecasVigentes(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.GetBecasVigentes)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    // RecuperarContrasenia
    func RecuperarContrasenia(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.RecuperarContrasenia)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    // 2.29 GetPaises
    func GetPaises(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.GetPaises)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    

    
    // 2.30 BuscarCodigoPostal
    func BuscarCodigoPostal(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.BuscarCodigoPostal)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    // 2.31 EditarPerfil
    func EditarPerfil(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.EditarPerfil)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    
    //2.32 PostularseUniversidad
    func PostularseUniversidad(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.PostularseUniversidad)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    
    //2.33 GetPaquetesDisponibles
    func GetPaquetesDisponibles(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.GetPaquetesDisponibles)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    

    
    // ----------------------------
    
    // getTest
    func getTest(parameters: String, doneFunction:@escaping (Int,_ response: AnyObject) -> ()){
        let url =  "\(Config.desRutaWebServices)\(Singleton.GetCuponesVigentes)"
        sendRequest(url:url, requestMethod: "GET", jsonObject: parameters ){ response, error in
            if(error == nil){
                if let value = response {
                    let json = JSON(value)
                    if(json["Estatus"].numberValue == 1){
                        doneFunction(1, json as AnyObject)
                    }else{
                        doneFunction(0, (json["Mensaje"].stringValue as AnyObject?)!)
                    }
                }
            }else{
                doneFunction(-1, (Strings.error_conexion as AnyObject?)!)
            }
        }
    }
    
    
    
    
    
   
    
    
}
