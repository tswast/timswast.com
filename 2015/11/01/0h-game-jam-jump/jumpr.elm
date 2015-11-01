import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Mouse
import Touch
import Time exposing (..)
import Window


-- MODEL

type alias Model =
  { x : Float
  , y : Float
  , vx : Float
  , vy : Float
  , dir : Direction
  , moved : Bool
  , jumping : Bool
  , flagY : Float
  }


type Direction = Left | Right


type alias Keys = { x:Int, y:Int }


mario : Model
mario =
  { x = -300
  , y = 300
  , vx = 0
  , vy = 0
  , dir = Right
  , moved = False
  , jumping = False
  , flagY = 0
  }


-- UPDATE

ground : Model -> Float
ground mario = if mario.x < 0 then 300 else 0

update : (Float, Bool) -> Model -> Model
update (dt, b) mario =
  mario
    |> gravity dt
    |> jump b
    |> walk b
    |> physics dt


jump : Bool -> Model -> Model
jump b mario =
  if not b && mario.vy == 0 && mario.moved
    then { mario |
      vy      <- 6.0,
      jumping <- True,
      moved   <- False
    }
    else mario


gravity : Float -> Model -> Model
gravity dt mario =
  { mario |
      vy <- if mario.y > ground mario then mario.vy - dt/4 else 0
  }


physics : Float -> Model -> Model
physics dt mario =
  { mario |
      x <- if mario.x < 300 then mario.x + dt * mario.vx else -300,
      y <- max (ground mario) (mario.y + dt * mario.vy),
      flagY <- if (mario.x > 0 && mario.x < 160) then mario.y else mario.flagY
  }


walk : Bool -> Model -> Model
walk b mario =
  { mario |
      vx <- if mario.jumping || b then 2.5 else 0.0,
      dir <- Right,
      moved <- b || mario.moved
  }


-- VIEW

view : (Int, Int) -> Model -> Element
view (w',h') mario =
  let
    (w,h) = (toFloat w', toFloat h')

    verb =
      if  | mario.y > ground mario -> "jump"
          | mario.vx /= 0 -> "walk"
          | otherwise     -> "stand"

    dir =
      case mario.dir of
        Left -> "left"
        Right -> "right"

    -- for try elm site "/imgs/mario/"++ verb ++ "/" ++ dir ++ ".gif"
    src =
      "imgs/mario/"++ verb ++ "/" ++ dir ++ ".gif"

    marioImage =
      image 35 35 src

    groundY = 62 - h/2

    position =
      (mario.x, mario.y + groundY)
  in
    collage w' h'
      [ rect w h
          |> filled (rgb 174 238 238)
      , rect (w/2) 300
          |> filled (rgb 222 184 135)
          |> move (-w/4, 200 - h/2)
      , rect (2) 300
          |> filled (rgb 150 150 150)
          |> move (150, 200 - h/2)
      , ngon 3 20
          |> filled (rgb 100 200 100)
          |> move (160, 60 + mario.flagY - h/2)
      , rect w 50
          |> filled (rgb 74 167 43)
          |> move (0, 24 - h/2)
      , marioImage
          |> toForm
          |> move position
      ]


-- SIGNALS

main : Signal Element
main =
  Signal.map2 view Window.dimensions (Signal.foldp update mario input)

isNotEmpty : List a -> Bool
isNotEmpty ds = not (List.isEmpty ds)

touchIsDown : Signal Bool
touchIsDown =
  Signal.map isNotEmpty Touch.touches

buttonIsDown : Signal Bool
buttonIsDown =
  Signal.map2 (||) Mouse.isDown touchIsDown

input : Signal (Float, Bool)
input =
  let
    delta = Signal.map (\t -> t/20) (fps 30)
  in
    Signal.sampleOn delta (Signal.map2 (,) delta buttonIsDown)

