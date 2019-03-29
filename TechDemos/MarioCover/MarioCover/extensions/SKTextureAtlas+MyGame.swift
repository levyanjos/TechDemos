import GameKit

extension SKTextureAtlas {
    
    var allTextures : [SKTexture] {
        get {
            var frames = [SKTexture]()
            textureNames.forEach { frames.append(textureNamed($0)) }
            return frames
        }
    }
    
}
