//
//  Config.swift
//  verzity
//
//  Created by Jossue Betancourt on 18/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//
import UIKit

struct Config{
    static var desRutaWebServices = "http://verzity.dwmedios.com/WS/service/UNICONEKT.asmx/"
    static var desRutaMultimedia = "http://verzity.dwmedios.com/SITE/"
    static var cvPaypal : String?
    static var config_data = "http://www.dwmedios.com/UrlAppVerzity.json"
}

struct Strings {
    static var error_conexion = "Error de conexión"
}

final class Singleton {
    // Can't init is singleton
    private init() { }
    
    // MARK: Shared Instance
    static let shared = Singleton()
    
    //    Metodos de Webservice
    static let GetBecasVigentes = "GetBecasVigentes"
    static let GetCuponesVigentes = "GetCuponesVigentes"
    static let GetDetalleCupon = "GetDetalleCupon"
    static let IngresarAppUniversitario = "IngresarAppUniversitario"
    static let SolicitarFinanciamientos = "SolicitarFinanciamientos"
    static let GetFinanciamientosVigentes = "GetFinanciamientosVigentes"
    static let CrearCuentaAcceso = "CrearCuentaAcceso"
    static let IngresarAppUniversidad = "IngresarAppUniversidad"
    static let IngresarUniversitario = "IngresarUniversitario"
    static let BusquedaUniversidades = "BusquedaUniversidades"
    static let GetDetallesUniversidad = "GetDetallesUniversidad"
    static let GetBannersVigentes = "GetBannersVigentes"
    static let RegistrarVisitaBanners = "RegistrarVisitaBanners"
    static let GetProgramasAcademicos = "GetProgramasAcademicos"
    static let GetVideos = "GetVideos"
    static let PostularseBeca = "PostularseBeca"
    static let SetFavorito = "SetFavorito"
    static let GetFavoritos = "GetFavoritos"
    static let RegistrarUniversidad = "RegistrarUniversidad"
    static let GetPostulados = "GetPostulados"
    static let ConsultarNotificaciones = "ConsultarNotificaciones"
    static let GetDetalleNotificacion = "GetDetalleNotificacion"
    static let CanjearCupon = "CanjearCupon"
    
    
}
