/*
 Created by Levy Cristian  on 04/03/19.
 Copyright © 2019 Levy Cristian . All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.

*/

import UIKit
import SpriteKit

class Camera: SKCameraNode {
    
    // MARK: Properties
    
    // MARK: Váriaveis padrões
    
    /** O nó da câmera. Tudo que você querira que seja afetádo pela câmera deve ser filho desse nó. */
    let cenario: SKNode
    
    /** Limites do Tela do iPhone. O valor padrão é o size da View, mas esse valor pode ser mudado. */
    private var limitesdDaTela: CGRect
    
    /**  Limites do cenário. */
    private var cenarioFrame: CGRect
    
    /** Habilita/Desabilita a câmera. */
    var cameraHabilitada: Bool {
        didSet {
            //Habilita o gesture quando a câmera for habilitada
            pinchGestureRecognizer.isEnabled = cameraHabilitada
            
        }
    }
    
    /** Habilita/Desabilita o travamento da câmera */
    var travamentoHabilitado: Bool
    
    // MARK: Zoom in/out
    
    /** O atual valor da escala da câmera. */
    private var escalaZoom: CGFloat
    
    /** Min/Max possível da escala da câmera durante o zoom in/out. */
    var intervaloZoom: (min: CGFloat, max: CGFloat)
    
    /** Habilita/Desabilita o zoom da câmera. */
    var zoomHabilitado: Bool
    
    /** Gesture para o zoom da câmera. */
    var pinchGestureRecognizer: UIPinchGestureRecognizer!

    /** Determina a posição inicial do toque quando o usuário faz o pinchGesture. */
    private var posicaoInicialDoToque = CGPoint.zero
   
     // MARK: Navegação
    
     /** Gesture para o navegação da câmera. */
    private var swipeNavigation: UILongPressGestureRecognizer {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.updatePosition(_:)))
        longPressGestureRecognizer.numberOfTouchesRequired = 1
        longPressGestureRecognizer.numberOfTapsRequired = 0
        longPressGestureRecognizer.allowableMovement = 0
        longPressGestureRecognizer.minimumPressDuration = 0
        return longPressGestureRecognizer
    }
    
    /** Ultima Localização do toque na tela. */
    private var ultimaPosicaoDoToque: CGPoint!
    
    
    init(sceneView: SKView, cenario: SKNode) {
        //configurações iniciais da câmera
        self.cenario = cenario
        self.cenarioFrame = cenario.frame
        self.limitesdDaTela = sceneView.bounds

        //determina a escla inicial do zoom para 1
        escalaZoom = 1.0
        //determina o intervalo de escla do zoom para o intervalo [1,1.3]
        intervaloZoom = (1, 1.5)
        //habilita a câmera e o zoom
        zoomHabilitado = true
        cameraHabilitada = true
        //habilita o travamento da câmera para tentativa de sair do cenário
        travamentoHabilitado = true
        super.init()
        
        //adiciona o gesture a view da câmera
        pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.updateScale(_:)))
        sceneView.addGestureRecognizer(pinchGestureRecognizer)
        
        sceneView.addGestureRecognizer(swipeNavigation)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Escala e Zoom
    
    /** Aplica uma escala ao Cenário. */
    func applyZoomScale(scale: CGFloat) {
        
        var zoomScale = scale
        
        if zoomScale < intervaloZoom.min {
            zoomScale = intervaloZoom.min
        } else if zoomScale > intervaloZoom.max {
            zoomScale = intervaloZoom.max
        }
        
        self.escalaZoom = zoomScale
        cenario.setScale(zoomScale)
    }
    
    
    // MARK: Bounds
    
    /** Mantém o cenário travado em limites especificos. */
    private func clampWorldNode() {
        
        //A variável travamentoHabilitado precisa está habilitada para que os limites serem mantidos
        if !travamentoHabilitado { return }
        
        //Cálcula o limites da tela
        // Os cálculos do tipo (bounds.size.width / 2) são necessários para a compensação mátematica da câmera em relação ao seu anchor point. Mais informações na Parte 1 (o link é encontrado no final dessa parte).
        let frame = cenarioFrame
        var minX = frame.minX + (limitesdDaTela.size.width / 2)
        var maxX = frame.maxX - (limitesdDaTela.size.width / 2)
        var minY = frame.minY + (limitesdDaTela.size.height / 2)
        var maxY = frame.maxY - (limitesdDaTela.size.height / 2)
        
        
        //Essa verificações são necessárias para saber se o tamanho do cenário é menor do que o tamanho da View, se sim os valores são trocados.
        if frame.width < limitesdDaTela.width {
            swap(&minX, &maxX)
        }
        
        if frame.height < limitesdDaTela.height {
            swap(&minY, &maxY)
        }
        
        //Verifica se o usuário está nos limites. Caso ele ultrapasse algum deles, será setádo o seu respectivo valor min ou max .
        if position.x < minX {
            position.x = CGFloat(Int(minX))
        } else if position.x > maxX {
            position.x = CGFloat(Int(maxX))
        }
        
        if position.y < minY {
            position.y = CGFloat(Int(minY))
        } else if position.y > maxY {
            position.y = CGFloat(Int(maxY))
        }
        
    }
    
    // MARK: Posicionando
    
    /** Move a câmera pra uma posição checando seus limites. */
    func centerOnPosition(scenePosition: CGPoint) {
        // verifica se a escala está nos parametros válidos e atribui o valor recebido a posição da câmera(parte-2) e verifica se a ultima posição na tela não é nula(parte - 3)
        if (escalaZoom > intervaloZoom.min && escalaZoom < intervaloZoom.max) || ultimaPosicaoDoToque != nil {
             position = scenePosition
            clampWorldNode()
        }
       
    }
    
    // MARK: Input
    
    /** Escala o cenário a partir de um input proveniente do pinchGestureRecognizer.*/
    @objc func updateScale(_ recognizer: UIPinchGestureRecognizer) {
        
        guard let scene = self.scene else { return }
        
        //captura o primeiro toque do usuário
        if recognizer.state == .began {
            posicaoInicialDoToque = scene.convertPoint(fromView: recognizer.location(in: recognizer.view))
            
        }
        //Cálcula o zoom, aplica no cenário e centraliza a câmera.
        if recognizer.state == .changed && cameraHabilitada && zoomHabilitado {
            
            escalaZoom *= recognizer.scale
            applyZoomScale(scale: escalaZoom)
            recognizer.scale = 1
            centerOnPosition(scenePosition: CGPoint(x: posicaoInicialDoToque.x * escalaZoom, y: posicaoInicialDoToque.y * escalaZoom))
        }
        
        if recognizer.state == .ended { }
    }
    
    // MARK: Navegação pela tela
    
    /** Move a câmera pelo cenário a partir de input proveniente do pinchGestureRecognizer.*/
    @objc func updatePosition(_ recognizer: UILongPressGestureRecognizer) {
        
        if recognizer.state == .began {
            //salva a posição inicial do toque como ultima
            ultimaPosicaoDoToque = recognizer.location(in: recognizer.view)
        }
        
        if recognizer.state == .changed {
            
            if ultimaPosicaoDoToque == nil { return }
            
            let location = recognizer.location(in: recognizer.view)
            //cálcula o Δx e Δy da câmera
            let difference = CGPoint(x: location.x - ultimaPosicaoDoToque.x, y: location.y - ultimaPosicaoDoToque.y)
            //utiliza a função criada na postagem 2 para limitar a área do usuário
            centerOnPosition(scenePosition: CGPoint(x: Int(position.x - difference.x), y: Int(position.y - -difference.y)))
            ultimaPosicaoDoToque = location
        }
    }
}
