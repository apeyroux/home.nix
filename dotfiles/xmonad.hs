import           Control.Monad
import qualified Data.Map                            as M
import           Graphics.X11.ExtraTypes.XF86
import           System.IO
-- import           System.Taffybar.Support.PagerHints  (pagerHints)
import           XMonad
import           XMonad.Actions.Search               as S
import           XMonad.Actions.Submap               as SM
import           XMonad.Actions.Volume
import           XMonad.Config.Azerty
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.SetWMName
import           XMonad.Layout.MultiToggle
import           XMonad.Layout.MultiToggle.Instances
import           XMonad.Layout.NoBorders
import           XMonad.Layout.Tabbed
import           XMonad.Prompt
import           XMonad.Prompt.Shell
import           XMonad.Prompt.Workspace
import qualified XMonad.StackSet                     as W
-- https://hackage.haskell.org/package/xmonad-extras-0.15.1/docs/XMonad-Util-Brightness.html
import           XMonad.Util.Brightness              as Brightness
import           XMonad.Util.EZConfig
import           XMonad.Util.Loggers
import           XMonad.Util.Run                     (safeSpawn, spawnPipe)
import           XMonad.Util.Spotify

{--
http://xmonad.org/xmonad-docs/xmonad/XMonad-Core.html
http://xmonad.org/xmonad-docs/xmonad/src/XMonad-Core.html#XConfig
--}

term :: String
term = "kitty"

browser :: String
browser = "google-chrome"

amazonfr :: SearchEngine
amazonfr = searchEngine "amazonfr" "http://www.amazon.fr/s/ref=nb_sb_noss_2?url=search-alias%3Daps&field-keywords="

wikifr :: SearchEngine
wikifr = searchEngine "wikifr" "http://fr.wikipedia.org/wiki/Special:Search?go=Go&search="

photos :: SearchEngine
photos = searchEngine "photos" "https://photos.google.com/search/"

diigo :: SearchEngine
diigo = searchEngine "diigo" "https://www.diigo.com/user/apeyroux?snapshot=yes&query="

mapsfr :: SearchEngine
mapsfr = searchEngine "mapsfr" "http://maps.google.fr/maps?q="

youtubesfr :: SearchEngine
youtubesfr = searchEngine "yt" "http://www.youtube.fr/results?search_type=search_videos&search_query="

multiEngine :: SearchEngine
multiEngine = namedEngine "multifr" $ foldr1 (!>) [wikifr
                                                  , amazonfr
                                                  , mapsfr
                                                  , diigo
                                                  , youtubesfr
                                                  , images
                                                  , photos
                                                  , google]

myLayout = tiled
  ||| Mirror tiled
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 2/3
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

myLogHook proc = dynamicLogWithPP $ xmobarPP
  { ppOutput  = hPutStrLn proc
  , ppCurrent = currentStyle
  , ppVisible = visibleStyle
  , ppTitle   = titleStyle
  -- , ppSep = " <fn=1><fc=#ff1493>\xf101</fc></fn> "
  , ppSep = " "
  -- , ppLayout  = (\layout -> case layout of
  --     "Tall"        -> "[|]"
  --     "Mirror Tall" -> "[-]"
  --     "ThreeCol"    -> "[||]"
  --     "Tabbed"      -> "[_]"
  --     "Gimp"        -> "[&]"
  --     )
  }
  where
    currentStyle = xmobarColor "#fff" "" . wrap "<fc=#ff1493><fn=1>\xf105</fn></fc> " " <fc=#ff1493><fn=1>\xf104</fn></fc> "
    visibleStyle = wrap "(" ")"
    titleStyle   = xmobarColor "#fff" "" . shorten 200 . filterCurly
    filterCurly  = filter (not . isCurly)
    isCurly x = x == '{' || x == '}'

myKeys :: XConfig t -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@XConfig {XMonad.modMask = modMask} = M.fromList $
  [
    ((modMask .|. shiftMask, xK_m   ), workspacePrompt def (windows . W.shift))
  , ((modMask, xK_Up                ), windows W.focusUp)
  , ((modMask, xK_Down              ), windows W.focusDown)
  , ((modMask .|. shiftMask, xK_d   ), shellPrompt def)
  , ((modMask, xK_b                 ), sendMessage ToggleStruts)
  -- , ((modMask, xK_q                 ), spawn "pkill pasystray; pkill stalonetray; pkill udiskie; pkill volumeicon; pkill xfce4-power-man; pkill nm-applet; xmonad --recompile; xmonad --restart")
  , ((modMask, xK_d                 ), shellPrompt def)
  , ((modMask, xK_x                 ), spawn "slimlock")
  , ((modMask, xK_f                 ), sendMessage $ Toggle FULL)
  -- , ((modMask, xK_x              ), spawn "zeal")
  , ((0, xF86XK_AudioPlay ),
     safeSpawn "dbus-send" ["--print-reply",
                            "--dest=org.mpris.MediaPlayer2.spotify",
                            "/org/mpris/MediaPlayer2",
                            "org.mpris.MediaPlayer2.Player.PlayPause"])
  , ((0, xF86XK_AudioNext ),
     safeSpawn "dbus-send" ["--print-reply",
                            "--dest=org.mpris.MediaPlayer2.spotify",
                            "/org/mpris/MediaPlayer2",
                            "org.mpris.MediaPlayer2.Player.Next"])
  , ((0, xF86XK_AudioPrev ),
     safeSpawn "dbus-send" ["--print-reply",
                            "--dest=org.mpris.MediaPlayer2.spotify",
                            "/org/mpris/MediaPlayer2",
                            "org.mpris.MediaPlayer2.Player.Previous"])
  , ((noModMask, xF86XK_AudioLowerVolume), void (lowerVolumeChannels ["PulseAudio", "Master"] 3))
  , ((noModMask, xF86XK_AudioRaiseVolume), void (raiseVolumeChannels ["PulseAudio", "Master"] 3))
  , ((noModMask, xF86XK_AudioMute), void (toggleMuteChannels ["PulseAudio", "Master"]))
  , ((modMask, xK_Left              ), sendMessage Shrink)
  , ((modMask, xK_Right             ), sendMessage Expand)
  , ((noModMask, xF86XK_MonBrightnessUp             ), Brightness.increase)
  , ((noModMask, xF86XK_MonBrightnessDown             ), Brightness.decrease)
  -- , ((noModMask, xF86XK_MonBrightnessUp             ), spawn "hbrightness -m eDP-1 -a Up")
  -- , ((noModMask, xF86XK_MonBrightnessDown             ), spawn "hbrightness -m eDP-1 -a Down")
  -- , ((modMask .|. controlMask, xK_h ), spawn "xrandr --output HDMI1 --auto --output eDP1 --off")
  -- , ((modMask .|. shiftMask, xK_h   ), spawn "xrandr --output eDP1 --auto --output HDMI1 --off")
  -- , ((modMask .|. shiftMask, xK_h   ), spawn "hsdmi")
  , ((modMask, xK_e                 ), safeSpawn "pcmanfm" [])
  , ((modMask, xK_s                 ), promptSearchBrowser def browser multiEngine)
  , ((modMask .|. shiftMask, xK_s   ), selectSearchBrowser browser google)
  ]
  ++
  -- mod-{w,e,r} %! Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r} %! Move client to screen 1, 2, or 3
  [((m .|. modMask, key              ), screenWorkspace sc >>= flip whenJust (windows . f))
  | (key, sc) <- zip [xK_z, xK_e, xK_r] [0..]
  , (f, m) <- [(W.view, 0            ), (W.shift, shiftMask)]]

initx :: X()
initx = do
  setWMName "LG3D"
  -- spawn "feh --bg-scale /home/alex/.bg/bg.jpg"
  -- https://hackage.haskell.org/package/xmonad-extras-0.15/docs/XMonad-Util-Brightness.html
  spawn "sudo chgrp -R -H users /sys/class/backlight/intel_backlight"
  spawn "sudo chmod g+w /sys/class/backlight/intel_backlight/brightness"
  -- spawn "xembedsniproxy"
  -- spawn "status-notifier-item-static"
  -- spawn "status-notifier-watcher"
  -- spawn "pasystray"
  -- spawn "taffybar"
  -- spawn "dunst"
  spawn "insync start"
  -- spawn "tresorit-cli-impure start"
  -- spawn "protonmail-bridge -c --no-window -l info"
  -- spawn "protonmail-bridge -l debug --noninteractive --no-window"
  -- spawn "udiskie --appindicator -t  -f nautilus"
  -- spawn "nm-applet --sm-disable --indicator"
  spawn "xsetroot -solid '#282a36'"

main :: IO()
main = do
  xmobar <- spawnPipe "xmobar"
  -- xmonad $ ewmh $ docks $ pagerHints cfg
  xmonad $ ewmh (cfg xmobar)
  where
    cfg xbar = docks $ def {
      manageHook = manageDocks
               <+> (isFullscreen --> doFullFloat)
               <+> (className =? "Vlc" --> doFloat)
               <+> (className =? "VirtualBox Manager" --> doFloat)
               <+> (className =? "VirtualBox Machine" --> doFloat)
               <+> (className =? "VirtualBox Manager" --> doFloat)
               <+> (className =? "VirtualBox" --> doFloat)
               <+> (className =? "evince-previewer" --> doFloat)
               <+> (className =? "Evince" --> doFloat)
               <+> (className =? "Nylas Mail" --> doFloat)
               <+> (className =? "file-roller" --> doFloat)
               <+> (className =? "File-roller" --> doFloat)
               <+> (className =? "Nautilus" --> doCenterFloat)
               <+> (className =? "Zeal" --> doFloat)
               <+> (className =? "Tresorit" --> doFloat)
               <+> (className =? "gnome-calendar" --> doFloat)
               <+> (className =? "vlc" --> doFloat)
               <+> (className =? "Criptext" <||> className =? "criptext" --> doFloat)
               <+> (className =? "Pcmanfm" <||> className =? "pcmanfm" --> doFloat)
               <+> (className =? ".anbox-wrapped" --> doFloat)
               <+> (className =? "spotify" --> doShift "3")
               <+> (className =? "firefox" <||> title =? "chrome" --> doShift "2:www")
               <+> (className =? "google-chrome-stable" <||> title =? "google-chrome-stable" --> doShift "2:www")
               <+> (stringProperty "WM_WINDOW_ROLE" =? "browser" --> doShift "2:www")
               <+> (stringProperty "WM_WINDOW_ROLE" =? "pop-up" --> doFloat)
               <+> (className =? "Gimp" --> doFloat)
               <+> (className =? ".Desktop-Bridge-wrapped" --> doCenterFloat) -- protonmail bridge
               <+> (className =? "ProtonMail Bridge" --> doCenterFloat) -- protonmail bridge
               <+> (className =? "emacs" --> doShift "emacs")
               <+> (className =? "jetbrains-datagrip" --> doFloat)
               <+> (className =? "jetbrains-studio" --> doCenterFloat)
               <+> (className =? "Molotov" --> doCenterFloat)
               <+> (className =? "Pinentry" --> doFloat)
               <+> (className =? "Yubioath-gui" --> doFloat)
               <+> (className =? "yubioath-gui" --> doFloat)
               <+> (className =? "yubioath-desktop" --> doFloat)
               <+> (className =? "Yubico Authenticator" --> doFloat)
               <+> (className =? "Virt-manager" --> doFloat)
               <+> (className =? "sun-awt-X11-XFramePeer" --> doFloat)
               <+> (className =? "Antidote 9" --> doFloat)
               <+> (className =? "Pavucontrol" --> doCenterFloat)
               <+> (title =? "Authy" --> doFloat)
               <+> (className =? "stalonetray" --> doIgnore)
               <+> (title =? "Postman" --> doFloat)
               <+> manageHook def
               <+> composeOne [isFullscreen -?> doFullFloat ]
               <+> manageDocks,
    terminal = term,
    keys = \c -> azertyKeys c
                 <+> keys def c
                 <+> myKeys c,
    layoutHook = smartBorders $ avoidStruts $ mkToggle (NOBORDERS ?? FULL ?? EOT) myLayout,
    -- startupHook = initx <+> docksStartupHook <+> startupHook def,
    startupHook = initx <+> startupHook def,
    logHook = myLogHook xbar,
    borderWidth = 1,
    normalBorderColor  = "#44475a",
    focusedBorderColor = "#F333FF",
    -- workspaces = ["<fn=1><fc=#5dade2>\xf108</fc></fn>",
    --               "<fn=1><fc=#f5b041>\xf269</fc></fn>",
    --               "<fn=1><fc=#27ae60>\xf1bc</fc></fn>",
    --               "<fn=1><fc=#5dade2>\xf121</fc></fn>"] <+> map show [5..10],
    handleEventHook = fullscreenEventHook,
    modMask = mod4Mask
    }
