//
//  Menus.swift
//  verzity
//
//  Created by Jossue Betancourt on 21/06/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import UIKit

struct Menus{
  
    static let menu_main = [
        [
            "name":"Buscar universidades",
            "image":"ic_telefono.png",
            "type": "find_university"
        ],
        [
            "name":"Becas",
            "image":"ic_action_ic_openbook.png",
            "type": "becas"
        ],
        [
            "name":"Financiamiento",
            "image":"ic_action_financiamiento.png",
            "type": "financing"
        ],
        [
            "name":"Cupones y descuentos",
            "image":"ic_action_cupon.png",
            "type": "coupons"
        ],
        [
            "name":"Viaje al extranjero",
            "image":"ic_world.png",
            "type": "travel"
        ]
        
    ]
    
    static let menu_find_university = [
        [
            "name":"Universidad",
            "image":"ic_action_ic_school.png",
            "type": "find_university"
        ],
        [
            "name":"Programas académicos",
            "image":"ic_telefono.png",
            "type": "find_academics"
        ],
        [
            "name":"Cerca de mi",
            "image":"ic_telefono.png",
            "type": "find_next_to_me"
        ],
        [
            "name":"En EUU.",
            "image":"ic_action_aeroplane.png",
            "type": "find_euu"
        ],
        [
            "name":"Favoritos",
            "image":"ic_telefono.png",
            "type": "find_favorit"
        ]
        
    ]
    
    static let side_menu_university = [
        [],
        [
            "name":"Inicio",
            "image":"ic_action_ic_home.png",
            "type": "home_university"
        ],
        [
            "name":"Ver Perfil universitario",
            "image":"ic_action_ic_school.png",
            "type": "profile_university"
        ],
        [
            "name":"Cerrar sesión",
            "image":"ic_action_close.png",
            "type": "sigout"
        ]
        
        ] as [Any]
    
    static let side_menu_representative = [
        [],
        [
            "name":"Inicio",
            "image":"ic_action_ic_home.png",
            "type": "home_representative"
        ],
        [
            "name":"Ver Perfil universitario",
            "image":"ic_action_ic_school.png",
            "type": "profile_university"
        ],
        [
            "name":"Ver Perfil representante",
            "image":"ic_telefono.png",
            "type": "profile_representative"
        ],
        [
            "name":"Mensajes",
            "image":"ic_action_notifications.png",
            "type": "notifications_representative"
        ],
        [
            "name":"Cerrar sesión",
            "image":"ic_action_close.png",
            "type": "sigout"
        ]
        
        ] as [Any]
    
}