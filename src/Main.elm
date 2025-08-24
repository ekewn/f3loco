module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, a, br, div, h1, h2, header, img, li, nav, text, ul)
import Html.Attributes as Attr
import Platform.Sub as Sub
import Url exposing (Url)


-- MAIN

main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , subscriptions = always Sub.none
        , view = view
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }


-- MODEL

type alias Model =
    { key : Nav.Key
    , url : Url
    , page : Page
    }


type Page
    = About
    | ForNewGuys
    | Locations


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( { key = key, url = url, page = parseUrl url }
    , Cmd.none
    )


-- UPDATE

type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked req ->
            case req of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url, page = parseUrl url }, Cmd.none )


-- ROUTING

parseUrl : Url -> Page
parseUrl url =
    case url.fragment of
        Just "about" ->
            About

        Just "for-new-guys" ->
            ForNewGuys

        Just "locations" ->
            Locations

        _ ->
            About


-- VIEW

view : Model -> Browser.Document Msg
view model =
    { title = "F3 LOCO (Longmont, CO)"
    , body =
        [ viewHeader
        , viewNavbar
        , div [ Attr.class "content" ] [ viewPage model.page ]
        ]
    }


viewHeader : Html Msg
viewHeader =
    header [ Attr.class "site-header" ]
        [ img [ Attr.src "static/Header.jpg", Attr.alt "Header Image", Attr.class "header-img" ] [] ]


viewNavbar : Html Msg
viewNavbar =
    nav [ Attr.class "navbar" ]
        [ ul []
            [ navLink "#about" "About"
            , navLink "#for-new-guys" "FNG's"
            , navLink "#locations" "Locations"
            ]
        ]


navLink : String -> String -> Html Msg
navLink url label =
    li []
        [ a [ Attr.href url ] [ text label ] ]


viewPage : Page -> Html Msg
viewPage page =
    case page of
        About ->
            div [] [ h1 [] [ text "About" ], text "This is the Longmont chapter of the worldwide ", a [ Attr.href "https://f3nation.com" ] [ text "F3 Nation" ], text " a workout group aimed at cultivating Fitness, Fellowship, and Faith in all men." ]

        ForNewGuys ->
            div [] [ h1 [] [ text "FNG's" ], text "Welcome to F3!" ]

        Locations ->
            div []
                [ h1 [] [ text "Locations" ]
                , h2 [] [ text "Clark Centennial Park (Centennial)" ]
                , text "- Meeting Mondays and Wednesdays at 0530 for a 45 minute beatdown"
                , br [] []
                , a [ Attr.href "https://maps.app.goo.gl/jvH88u7Sb8G3xzDs8" ] [ text "- Google Maps" ]
                , br [] []
                , a [ Attr.href "https://f3longmont.slack.com/archives/C08P576TPT8" ] [ text "- Slack Channel" ]
                , h2 [] [ text "Dry Creek Park (The Precipice)" ]
                , text "- Meeting Fridays at 0530 for a 45 minute beatdown"
                , br [] []
                , a [ Attr.href "https://maps.app.goo.gl/oCvzTreNARPiCZKq9" ] [ text "- Google Maps" ]
                , br [] []
                , a [ Attr.href "https://f3longmont.slack.com/archives/C092H0LJ0KW" ] [ text "- Slack Channel" ]
                ]
