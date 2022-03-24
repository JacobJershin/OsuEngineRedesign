import Scenes
import Igis
import Foundation

  /*
     This class is responsible for rendering the background.
   */

let CS = 4*35
let X = 115
let Y = 212

func sqrt(num:Int)-> Double {
    var x1:Double = (Double(num) * 1.0) / 2;
    var x2:Double = (x1 + (Double(num) / x1)) / 2;
    while(abs(x1 - x2) >= 0.0000001){
        x1 = x2;
        x2 = (x1 + (Double(num) / x1)) / 2;
    }
    return Double(x2);
}

class Background : RenderableEntity {

    let hitCircle : Image
    let Number : Image

    init() {
        guard let HitObjURL = URL(string:"https://codermerlin.com/users/jacob-jershin/assets/hitcircle.png") else {
            fatalError("Failed to create URL for HitObj")
        }
        guard let NumberURL = URL(string:"https://codermerlin.com/users/jacob-jershin/assets/default-1%402x.png") else {
            fatalError("Failed to create URL for HitObj1")
        }

        hitCircle = Image(sourceURL:HitObjURL)
        Number = Image(sourceURL:NumberURL)
        
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Background")
    }
    override func setup(canvasSize:Size, canvas:Canvas) {
        canvas.setup(hitCircle)
        canvas.setup(Number)
    }
    override func render(canvas:Canvas) {
        if hitCircle.isReady {
            hitCircle.renderMode = .destinationRect(Rect(topLeft:Point(x:X, y:Y), size:Size(width:CS, height:CS)))
            canvas.render(hitCircle)
        }

        if Number.isReady {
            Number.renderMode = .destinationRect(Rect(topLeft:Point(x:X+Int(sqrt(num:CS*2)), y:Y+Int(sqrt(num:CS*2))), size:Size(width:CS/2, height:CS/2)))
            canvas.render(Number)
        }
        
    }
}
