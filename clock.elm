import Html exposing (Html)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, millisecond)

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL
type alias Model = 
  { time : Time
  , clockColor: String
  }


init : (Model, Cmd Msg)
init =
  ({ time = 0, clockColor = "#0B79CE" }, Cmd.none)

-- UPDATE
type Msg
  = Tick Time
  | ChangeColor


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      ({ model | time = newTime }, Cmd.none)
    ChangeColor ->
      ({ model | clockColor = getClockColor }, Cmd.none)


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every millisecond Tick

-- FUNCS
getClockColor : String
getClockColor =
  "#6767ac"

-- VIEW
view : Model -> Html Msg
view model =
  let
    angleSec =
      turns (Time.inMinutes model.time)

    handXSec =
      toString (50 + 40 * cos angleSec)

    handYSec =
      toString (50 + 40 * sin angleSec)
      
    angleMin =
      turns (Time.inHours model.time)

    handXMin =
      toString (50 + 20 * cos angleMin)

    handYMin =
      toString (50 + 20 * sin angleMin)
  in
    Html.div [] 
    [ Html.button [ onClick ChangeColor ] [ Html.text "color switch" ]
    , svg [ viewBox "0 0 100 100", width "300px" ]
      [ circle [ cx "50", cy "50", r "45", fill model.clockColor ] []
      , line [ x1 "50", y1 "50", x2 handXMin, y2 handYMin, stroke "#F23A88" ] []
      , line [ x1 "50", y1 "50", x2 handXSec, y2 handYSec, stroke "#023963" ] []
      , circle [ cx "50", cy "50", r "1", fill model.clockColor ] []
      ]
    ]

