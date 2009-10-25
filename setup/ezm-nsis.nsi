;================================
; EZ MP3 Creator Install Script
;================================


;--------------------------------
; Constants

  !define COMPANY_NAME "Linasoft"
  !define PRODUCT_NAME "EZ MP3 Creator"
  !define PRODUCT_VER  "1.5.2"
  !define PRODUCT_NAME_SHORT "ezmp3c"

;--------------------------------
; Variables

  Var MUI_TEMP
  Var STARTMENU_FOLDER

;--------------------------------
; Include Modern UI

  !include "MUI.nsh"

;--------------------------------
; Configuration

  ;General
  Name "${PRODUCT_NAME} ${PRODUCT_VER}"
  OutFile "${PRODUCT_NAME_SHORT}_${PRODUCT_VER}.exe"

  ;Compression
  SetCompressor /SOLID lzma

  ;Plugin Directory
  !addplugindir .

  ;Install Folder
  InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"
  InstallDirRegKey HKCU "Software\${COMPANY_NAME}\${PRODUCT_NAME}" ""

  ;Install Language
  !define MUI_LANGDLL_REGISTRY_ROOT "HKCU"
  !define MUI_LANGDLL_REGISTRY_KEY "Software\${COMPANY_NAME}\${PRODUCT_NAME}"
  !define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"
  !define MUI_LANGDLL_ALLLANGUAGES

;--------------------------------
; Interface Settings

  !define MUI_ABORTWARNING

  !define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
  !define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"

  !define MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange.bmp"

  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\orange.bmp"
  !define MUI_HEADERIMAGE_UNBITMAP "${NSISDIR}\Contrib\Graphics\Header\orange-uninstall.bmp"

;--------------------------------
; Pages

  !insertmacro MUI_PAGE_WELCOME

  !insertmacro MUI_PAGE_LICENSE $(LicenseFile)

  !insertmacro MUI_PAGE_DIRECTORY

  ;Start Menu Folder Page Configuration
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU"
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\${COMPANY_NAME}\${PRODUCT_NAME}"
  !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
  !define MUI_STARTMENUPAGE_DEFAULTFOLDER "${PRODUCT_NAME}"
  !define MUI_STARTMENUPAGE_NODISABLE
  !insertmacro MUI_PAGE_STARTMENU Application $STARTMENU_FOLDER

  !insertmacro MUI_PAGE_INSTFILES

  !define MUI_FINISHPAGE_RUN "$INSTDIR\ezmp3c.exe"
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
; Languages

  !insertmacro MUI_LANGUAGE "English"
  !insertmacro MUI_LANGUAGE "Albanian"
  !insertmacro MUI_LANGUAGE "Arabic"
  !insertmacro MUI_LANGUAGE "Bosnian"
  !insertmacro MUI_LANGUAGE "Bulgarian"
  !insertmacro MUI_LANGUAGE "Catalan"
  !insertmacro MUI_LANGUAGE "Czech"
  !insertmacro MUI_LANGUAGE "Danish"
  !insertmacro MUI_LANGUAGE "Dutch"
  !insertmacro MUI_LANGUAGE "Estonian"
  !insertmacro MUI_LANGUAGE "Farsi"
  !insertmacro MUI_LANGUAGE "Finnish"
  !insertmacro MUI_LANGUAGE "French"
  ;!insertmacro MUI_LANGUAGE "Gaelic"
  !insertmacro MUI_LANGUAGE "German"
  !insertmacro MUI_LANGUAGE "Greek"
  !insertmacro MUI_LANGUAGE "Hebrew"
  !insertmacro MUI_LANGUAGE "Hungarian"
  !insertmacro MUI_LANGUAGE "Indonesian"
  !insertmacro MUI_LANGUAGE "Italian"
  !insertmacro MUI_LANGUAGE "Korean"
  !insertmacro MUI_LANGUAGE "Latvian"
  !insertmacro MUI_LANGUAGE "Lithuanian"
  !insertmacro MUI_LANGUAGE "Norwegian"
  !insertmacro MUI_LANGUAGE "Polish"
  !insertmacro MUI_LANGUAGE "Portuguese"
  !insertmacro MUI_LANGUAGE "PortugueseBR"
  !insertmacro MUI_LANGUAGE "Romanian"
  !insertmacro MUI_LANGUAGE "Russian"
  !insertmacro MUI_LANGUAGE "Serbian"
  !insertmacro MUI_LANGUAGE "SimpChinese"
  !insertmacro MUI_LANGUAGE "Slovenian"
  !insertmacro MUI_LANGUAGE "Spanish"
  !insertmacro MUI_LANGUAGE "Swedish"
  !insertmacro MUI_LANGUAGE "Thai"
  !insertmacro MUI_LANGUAGE "TradChinese"
  !insertmacro MUI_LANGUAGE "Turkish"
  !insertmacro MUI_LANGUAGE "Ukrainian"
  ;!insertmacro MUI_LANGUAGE "Vietnamese"

;--------------------------------
;Reserve Files
  
  ;If you are using solid compression, files that are required before
  ;the actual installation should be stored first in the data block,
  ;because this will make your installer start faster.
  
  !insertmacro MUI_RESERVEFILE_LANGDLL

;--------------------------------
; License File

  LicenseLangString LicenseFile ${LANG_ALBANIAN} "../COPYING"
  LicenseLangString LicenseFile ${LANG_ARABIC} "../COPYING"
  LicenseLangString LicenseFile ${LANG_BOSNIAN} "../COPYING"
  LicenseLangString LicenseFile ${LANG_BULGARIAN} "../COPYING"
  LicenseLangString LicenseFile ${LANG_CATALAN} "../COPYING"
  LicenseLangString LicenseFile ${LANG_CZECH} "../COPYING"
  LicenseLangString LicenseFile ${LANG_DANISH} "../COPYING"
  LicenseLangString LicenseFile ${LANG_DUTCH} "../COPYING"
  LicenseLangString LicenseFile ${LANG_ENGLISH} "../COPYING"
  LicenseLangString LicenseFile ${LANG_ESTONIAN} "../COPYING"
  LicenseLangString LicenseFile ${LANG_FARSI} "../COPYING"
  LicenseLangString LicenseFile ${LANG_FINNISH} "../COPYING"
  LicenseLangString LicenseFile ${LANG_FRENCH} "../COPYING"
; LicenseLangString LicenseFile ${LANG_GAELIC} "../COPYING"
  LicenseLangString LicenseFile ${LANG_GERMAN} "../COPYING"
  LicenseLangString LicenseFile ${LANG_GREEK} "../COPYING"
  LicenseLangString LicenseFile ${LANG_HEBREW} "../COPYING"
  LicenseLangString LicenseFile ${LANG_HUNGARIAN} "../COPYING"
  LicenseLangString LicenseFile ${LANG_INDONESIAN} "../COPYING"
  LicenseLangString LicenseFile ${LANG_ITALIAN} "../COPYING"
  LicenseLangString LicenseFile ${LANG_KOREAN} "../COPYING"
  LicenseLangString LicenseFile ${LANG_LATVIAN} "../COPYING"
  LicenseLangString LicenseFile ${LANG_LITHUANIAN} "../COPYING"
  LicenseLangString LicenseFile ${LANG_NORWEGIAN} "../COPYING"
  LicenseLangString LicenseFile ${LANG_POLISH} "../COPYING"
  LicenseLangString LicenseFile ${LANG_PORTUGUESE} "../COPYING"
  LicenseLangString LicenseFile ${LANG_PORTUGUESEBR} "../COPYING"
  LicenseLangString LicenseFile ${LANG_ROMANIAN} "../COPYING"
  LicenseLangString LicenseFile ${LANG_RUSSIAN} "../COPYING"
  LicenseLangString LicenseFile ${LANG_SERBIAN} "../COPYING"
  LicenseLangString LicenseFile ${LANG_SIMPCHINESE} "../COPYING"
  LicenseLangString LicenseFile ${LANG_SLOVENIAN} "../COPYING"
  LicenseLangString LicenseFile ${LANG_SPANISH} "../COPYING"
  LicenseLangString LicenseFile ${LANG_SWEDISH} "../COPYING"
  LicenseLangString LicenseFile ${LANG_THAI} "../COPYING"
  LicenseLangString LicenseFile ${LANG_TRADCHINESE} "../COPYING"
  LicenseLangString LicenseFile ${LANG_TURKISH} "../COPYING"
  LicenseLangString LicenseFile ${LANG_UKRAINIAN} "../COPYING"
; LicenseLangString LicenseFile ${LANG_VIETNAMESE} "../COPYING"

;--------------------------------
; XP AutoPlay Description

  LangString XPAutoPlayDescription ${LANG_ALBANIAN} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_ARABIC} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_BOSNIAN} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_BULGARIAN} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_CATALAN} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_CZECH} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_DANISH} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_DUTCH} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_ENGLISH} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_ESTONIAN} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_FARSI} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_FINNISH} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_FRENCH} "Copy Music from CD"
; LangString XPAutoPlayDescription ${LANG_GAELIC} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_GERMAN} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_GREEK} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_HEBREW} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_HUNGARIAN} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_INDONESIAN} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_ITALIAN} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_KOREAN} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_LATVIAN} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_LITHUANIAN} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_NORWEGIAN} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_POLISH} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_PORTUGUESE} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_PORTUGUESEBR} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_ROMANIAN} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_RUSSIAN} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_SERBIAN} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_SIMPCHINESE} "从 CD 复制音乐"
  LangString XPAutoPlayDescription ${LANG_SLOVENIAN} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_SPANISH} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_SWEDISH} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_THAI} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_TRADCHINESE} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_TURKISH} "Copy Music from CD"
  LangString XPAutoPlayDescription ${LANG_UKRAINIAN} "Copy Music from CD"
; LangString XPAutoPlayDescription ${LANG_VIETNAMESE} "Copy Music from CD"

;--------------------------------
; Language File

  LangString LanguageFile ${LANG_ALBANIAN} "Albanian"
  LangString LanguageFile ${LANG_ARABIC} "Arabic"
  LangString LanguageFile ${LANG_BOSNIAN} "Bosnian"
  LangString LanguageFile ${LANG_BULGARIAN} "Bulgarian"
  LangString LanguageFile ${LANG_CATALAN} "Catalan"
  LangString LanguageFile ${LANG_CZECH} "Czech"
  LangString LanguageFile ${LANG_DANISH} "Danish"
  LangString LanguageFile ${LANG_DUTCH} "Dutch"
  LangString LanguageFile ${LANG_ENGLISH} "English"
  LangString LanguageFile ${LANG_ESTONIAN} "Estonian"
  LangString LanguageFile ${LANG_FARSI} "Farsi"
  LangString LanguageFile ${LANG_FINNISH} "Finnish"
  LangString LanguageFile ${LANG_FRENCH} "French"
; LangString LanguageFile ${LANG_GAELIC} "Gaelic"
  LangString LanguageFile ${LANG_GERMAN} "German"
  LangString LanguageFile ${LANG_GREEK} "Greek"
  LangString LanguageFile ${LANG_HEBREW} "Hebrew (New)"
  LangString LanguageFile ${LANG_HUNGARIAN} "Hungarian"
  LangString LanguageFile ${LANG_INDONESIAN} "Indonesian"
  LangString LanguageFile ${LANG_ITALIAN} "Italian"
  LangString LanguageFile ${LANG_KOREAN} "Korean"
  LangString LanguageFile ${LANG_LATVIAN} "Latvian"
  LangString LanguageFile ${LANG_LITHUANIAN} "Lithuanian"
  LangString LanguageFile ${LANG_NORWEGIAN} "Norwegian"
  LangString LanguageFile ${LANG_POLISH} "Polish"
  LangString LanguageFile ${LANG_PORTUGUESE} "Portuguese"
  LangString LanguageFile ${LANG_PORTUGUESEBR} "Portuguese (Brazil)"
  LangString LanguageFile ${LANG_ROMANIAN} "Romanian (New)"
  LangString LanguageFile ${LANG_RUSSIAN} "Russian (New)"
  LangString LanguageFile ${LANG_SERBIAN} "Serbian"
  LangString LanguageFile ${LANG_SIMPCHINESE} "Chinese (Simplified)"
  LangString LanguageFile ${LANG_SLOVENIAN} "Slovenian"
  LangString LanguageFile ${LANG_SPANISH} "Spanish"
  LangString LanguageFile ${LANG_SWEDISH} "Swedish"
  LangString LanguageFile ${LANG_THAI} "Thai"
  LangString LanguageFile ${LANG_TRADCHINESE} "Chinese (Traditional)"
  LangString LanguageFile ${LANG_TURKISH} "Turkish"
  LangString LanguageFile ${LANG_UKRAINIAN} "Ukrainian"
; LangString LanguageFile ${LANG_VIETNAMESE} "Vietnamese"

;--------------------------------
; Help File

  LangString HelpFile ${LANG_ALBANIAN} "ezmp3c.chm"
  LangString HelpFile ${LANG_ARABIC} "ezmp3c.chm"
  LangString HelpFile ${LANG_BOSNIAN} "ezmp3c.chm"
  LangString HelpFile ${LANG_BULGARIAN} "ezmp3c.chm"
  LangString HelpFile ${LANG_CATALAN} "ezmp3c.chm"
  LangString HelpFile ${LANG_CZECH} "ezmp3c.chm"
  LangString HelpFile ${LANG_DANISH} "ezmp3c.chm"
  LangString HelpFile ${LANG_DUTCH} "ezmp3c.chm"
  LangString HelpFile ${LANG_ENGLISH} "ezmp3c.chm"
  LangString HelpFile ${LANG_ESTONIAN} "ezmp3c.chm"
  LangString HelpFile ${LANG_FARSI} "ezmp3c.chm"
  LangString HelpFile ${LANG_FINNISH} "ezmp3c.chm"
  LangString HelpFile ${LANG_FRENCH} "ezmp3c.chm"
; LangString HelpFile ${LANG_GAELIC} "ezmp3c.chm"
  LangString HelpFile ${LANG_GERMAN} "ezmp3c.chm"
  LangString HelpFile ${LANG_GREEK} "ezmp3c.chm"
  LangString HelpFile ${LANG_HEBREW} "ezmp3c.chm"
  LangString HelpFile ${LANG_HUNGARIAN} "ezmp3c.chm"
  LangString HelpFile ${LANG_INDONESIAN} "ezmp3c.chm"
  LangString HelpFile ${LANG_ITALIAN} "ezmp3c.chm"
  LangString HelpFile ${LANG_KOREAN} "ezmp3c.chm"
  LangString HelpFile ${LANG_LATVIAN} "ezmp3c.chm"
  LangString HelpFile ${LANG_LITHUANIAN} "ezmp3c.chm"
  LangString HelpFile ${LANG_NORWEGIAN} "ezmp3c.chm"
  LangString HelpFile ${LANG_POLISH} "ezmp3c.chm"
  LangString HelpFile ${LANG_PORTUGUESE} "ezmp3c.chm"
  LangString HelpFile ${LANG_PORTUGUESEBR} "ezmp3c.chm"
  LangString HelpFile ${LANG_ROMANIAN} "ezmp3c.chm"
  LangString HelpFile ${LANG_RUSSIAN} "ezmp3c.chm"
  LangString HelpFile ${LANG_SERBIAN} "ezmp3c.chm"
  LangString HelpFile ${LANG_SIMPCHINESE} "ezmp3c.zhcn.chm"
  LangString HelpFile ${LANG_SLOVENIAN} "ezmp3c.chm"
  LangString HelpFile ${LANG_SPANISH} "ezmp3c.es.chm"
  LangString HelpFile ${LANG_SWEDISH} "ezmp3c.chm"
  LangString HelpFile ${LANG_THAI} "ezmp3c.chm"
  LangString HelpFile ${LANG_TRADCHINESE} "ezmp3c.chm"
  LangString HelpFile ${LANG_TURKISH} "ezmp3c.chm"
  LangString HelpFile ${LANG_UKRAINIAN} "ezmp3c.chm"
; LangString HelpFile ${LANG_VIETNAMESE} "ezmp3c.chm"

;--------------------------------
; Shortcut Strings

  LangString HelpStr ${LANG_ALBANIAN} "Help"
  LangString HelpStr ${LANG_ARABIC} "Help"
  LangString HelpStr ${LANG_BOSNIAN} "Help"
  LangString HelpStr ${LANG_BULGARIAN} "Help"
  LangString HelpStr ${LANG_CATALAN} "Help"
  LangString HelpStr ${LANG_CZECH} "Help"
  LangString HelpStr ${LANG_DANISH} "Help"
  LangString HelpStr ${LANG_DUTCH} "Help"
  LangString HelpStr ${LANG_ENGLISH} "Help"
  LangString HelpStr ${LANG_ESTONIAN} "Help"
  LangString HelpStr ${LANG_FARSI} "Help"
  LangString HelpStr ${LANG_FINNISH} "Help"
  LangString HelpStr ${LANG_FRENCH} "Help"
; LangString HelpStr ${LANG_GAELIC} "Help"
  LangString HelpStr ${LANG_GERMAN} "Help"
  LangString HelpStr ${LANG_GREEK} "Help"
  LangString HelpStr ${LANG_HEBREW} "Help"
  LangString HelpStr ${LANG_HUNGARIAN} "Help"
  LangString HelpStr ${LANG_INDONESIAN} "Help"
  LangString HelpStr ${LANG_ITALIAN} "Help"
  LangString HelpStr ${LANG_KOREAN} "Help"
  LangString HelpStr ${LANG_LATVIAN} "Help"
  LangString HelpStr ${LANG_LITHUANIAN} "Help"
  LangString HelpStr ${LANG_NORWEGIAN} "Help"
  LangString HelpStr ${LANG_POLISH} "Help"
  LangString HelpStr ${LANG_PORTUGUESE} "Help"
  LangString HelpStr ${LANG_PORTUGUESEBR} "Help"
  LangString HelpStr ${LANG_ROMANIAN} "Help"
  LangString HelpStr ${LANG_RUSSIAN} "Help"
  LangString HelpStr ${LANG_SERBIAN} "Help"
  LangString HelpStr ${LANG_SIMPCHINESE} "帮助"
  LangString HelpStr ${LANG_SLOVENIAN} "Help"
  LangString HelpStr ${LANG_SPANISH} "Help"
  LangString HelpStr ${LANG_SWEDISH} "Help"
  LangString HelpStr ${LANG_THAI} "Help"
  LangString HelpStr ${LANG_TRADCHINESE} "Help"
  LangString HelpStr ${LANG_TURKISH} "Help"
  LangString HelpStr ${LANG_UKRAINIAN} "Help"
; LangString HelpStr ${LANG_VIETNAMESE} "Help"

  LangString UninstallStr ${LANG_ALBANIAN} "Uninstall"
  LangString UninstallStr ${LANG_ARABIC} "Uninstall"
  LangString UninstallStr ${LANG_BOSNIAN} "Uninstall"
  LangString UninstallStr ${LANG_BULGARIAN} "Uninstall"
  LangString UninstallStr ${LANG_CATALAN} "Uninstall"
  LangString UninstallStr ${LANG_CZECH} "Uninstall"
  LangString UninstallStr ${LANG_DANISH} "Uninstall"
  LangString UninstallStr ${LANG_DUTCH} "Uninstall"
  LangString UninstallStr ${LANG_ENGLISH} "Uninstall"
  LangString UninstallStr ${LANG_ESTONIAN} "Uninstall"
  LangString UninstallStr ${LANG_FARSI} "Uninstall"
  LangString UninstallStr ${LANG_FINNISH} "Uninstall"
  LangString UninstallStr ${LANG_FRENCH} "Uninstall"
; LangString UninstallStr ${LANG_GAELIC} "Uninstall"
  LangString UninstallStr ${LANG_GERMAN} "Uninstall"
  LangString UninstallStr ${LANG_GREEK} "Uninstall"
  LangString UninstallStr ${LANG_HEBREW} "Uninstall"
  LangString UninstallStr ${LANG_HUNGARIAN} "Uninstall"
  LangString UninstallStr ${LANG_INDONESIAN} "Uninstall"
  LangString UninstallStr ${LANG_ITALIAN} "Uninstall"
  LangString UninstallStr ${LANG_KOREAN} "Uninstall"
  LangString UninstallStr ${LANG_LATVIAN} "Uninstall"
  LangString UninstallStr ${LANG_LITHUANIAN} "Uninstall"
  LangString UninstallStr ${LANG_NORWEGIAN} "Uninstall"
  LangString UninstallStr ${LANG_POLISH} "Uninstall"
  LangString UninstallStr ${LANG_PORTUGUESE} "Uninstall"
  LangString UninstallStr ${LANG_PORTUGUESEBR} "Uninstall"
  LangString UninstallStr ${LANG_ROMANIAN} "Uninstall"
  LangString UninstallStr ${LANG_RUSSIAN} "Uninstall"
  LangString UninstallStr ${LANG_SERBIAN} "Uninstall"
  LangString UninstallStr ${LANG_SIMPCHINESE} "卸载"
  LangString UninstallStr ${LANG_SLOVENIAN} "Uninstall"
  LangString UninstallStr ${LANG_SPANISH} "Uninstall"
  LangString UninstallStr ${LANG_SWEDISH} "Uninstall"
  LangString UninstallStr ${LANG_THAI} "Uninstall"
  LangString UninstallStr ${LANG_TRADCHINESE} "Uninstall"
  LangString UninstallStr ${LANG_TURKISH} "Uninstall"
  LangString UninstallStr ${LANG_UKRAINIAN} "Uninstall"
; LangString UninstallStr ${LANG_VIETNAMESE} "Uninstall"

;--------------------------------
; WMA Priviilege Prompt

  LangString WMAPriviilegePrompt ${LANG_ALBANIAN} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_ARABIC} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_BOSNIAN} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_BULGARIAN} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_CATALAN} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_CZECH} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_DANISH} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_DUTCH} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_ENGLISH} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_ESTONIAN} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_FARSI} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_FINNISH} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_FRENCH} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
; LangString WMAPriviilegePrompt ${LANG_GAELIC} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_GERMAN} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_GREEK} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_HEBREW} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_HUNGARIAN} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_INDONESIAN} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_ITALIAN} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_KOREAN} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_LATVIAN} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_LITHUANIAN} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_NORWEGIAN} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_POLISH} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_PORTUGUESE} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_PORTUGUESEBR} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_ROMANIAN} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_RUSSIAN} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_SERBIAN} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_SIMPCHINESE} "您必须以管理员身份登录才能安装 Windows Media Audio 组件, 缺少该组件, 本程序将缺失WMA编码功能!"
  LangString WMAPriviilegePrompt ${LANG_SLOVENIAN} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_SPANISH} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_SWEDISH} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_THAI} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_TRADCHINESE} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_TURKISH} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
  LangString WMAPriviilegePrompt ${LANG_UKRAINIAN} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"
; LangString WMAPriviilegePrompt ${LANG_VIETNAMESE} "You must be logged in as an administrator to install Windows Media Audio component, the WMA encoding function won't be available without this component!"

;--------------------------------
; Keep Configuration Prompt

  LangString KeepConfigurationPrompt ${LANG_ALBANIAN} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_ARABIC} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_BOSNIAN} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_BULGARIAN} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_CATALAN} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_CZECH} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_DANISH} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_DUTCH} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_ENGLISH} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_ESTONIAN} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_FARSI} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_FINNISH} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_FRENCH} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
; LangString KeepConfigurationPrompt ${LANG_GAELIC} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_GERMAN} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_GREEK} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_HEBREW} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_HUNGARIAN} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_INDONESIAN} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_ITALIAN} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_KOREAN} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_LATVIAN} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_LITHUANIAN} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_NORWEGIAN} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_POLISH} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_PORTUGUESE} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_PORTUGUESEBR} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_ROMANIAN} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_RUSSIAN} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_SERBIAN} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_SIMPCHINESE} "是否保留 ${PRODUCT_NAME} 的相关配置 ?"
  LangString KeepConfigurationPrompt ${LANG_SLOVENIAN} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_SPANISH} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_SWEDISH} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_THAI} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_TRADCHINESE} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_TURKISH} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
  LangString KeepConfigurationPrompt ${LANG_UKRAINIAN} "Do you want to keep the configuration of ${PRODUCT_NAME}?"
; LangString KeepConfigurationPrompt ${LANG_VIETNAMESE} "Do you want to keep the configuration of ${PRODUCT_NAME}?"

;--------------------------------
;Installer Sections

Section "${PRODUCT_NAME}" SecCore

  SetOverwrite on

  SetOutPath $INSTDIR
  File "..\bin\ezmp3c.exe"
  File "..\bin\ezmp3c.chm"
  File "..\bin\ezmp3c.es.chm"
  File "..\bin\ezmp3c.zhcn.chm"
  File "..\bin\ezutils.dll"
  File "..\bin\akrip32.dll"
  File "..\bin\gogo.dll"
  File "..\bin\wmaenc.dll"
  File "..\bin\libogg-0.dll"
  File "..\bin\libvorbis-0.dll"
  File "..\bin\libvorbisenc-2.dll"
  File "..\COPYING"

  SetOutPath $INSTDIR\languages
  File "..\bin\languages\Albanian.lng"
  File "..\bin\languages\Arabic.lng"
  File "..\bin\languages\Bosnian.lng"
  File "..\bin\languages\Bulgarian.lng"
  File "..\bin\languages\Catalan.lng"
  File "..\bin\languages\Chinese (Simplified).lng"
  File "..\bin\languages\Chinese (Traditional).lng"
  File "..\bin\languages\Czech.lng"
  File "..\bin\languages\Danish.lng"
  File "..\bin\languages\Dutch.lng"
  File "..\bin\languages\English.lng"
  File "..\bin\languages\Estonian.lng"
  File "..\bin\languages\Farsi.lng"
  File "..\bin\languages\Finnish.lng"
  File "..\bin\languages\French.lng"
  File "..\bin\languages\Gaelic.lng"
  File "..\bin\languages\German.lng"
  File "..\bin\languages\Greek.lng"
  File "..\bin\languages\Hebrew (New).lng"
  File "..\bin\languages\Hebrew.lng"
  File "..\bin\languages\Hungarian.lng"
  File "..\bin\languages\Indonesian.lng"
  File "..\bin\languages\Italian.lng"
  File "..\bin\languages\Korean.lng"
  File "..\bin\languages\Latvian.lng"
  File "..\bin\languages\Lithuanian.lng"
  File "..\bin\languages\Norwegian.lng"
  File "..\bin\languages\Polish.lng"
  File "..\bin\languages\Portuguese (Brazil).lng"
  File "..\bin\languages\Portuguese.lng"
  File "..\bin\languages\Romanian (New).lng"
  File "..\bin\languages\Romanian.lng"
  File "..\bin\languages\Russian (New).lng"
  File "..\bin\languages\Russian.lng"
  File "..\bin\languages\Serbian.lng"
  File "..\bin\languages\Slovenian.lng"
  File "..\bin\languages\Spanish.lng"
  File "..\bin\languages\Swedish.lng"
  File "..\bin\languages\Thai.lng"
  File "..\bin\languages\Turkish.lng"
  File "..\bin\languages\Ukrainian.lng"
  File "..\bin\languages\Vietnamese.lng"
  WriteRegStr HKCU "Software\${COMPANY_NAME}\${PRODUCT_NAME}\Options" "Language" "$(LanguageFile)"

  ;Store Install Folder
  WriteRegStr HKCU "Software\${COMPANY_NAME}\${PRODUCT_NAME}" "" $INSTDIR

  ;Create Uninstaller
  WriteUninstaller "$INSTDIR\uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayName" "${PRODUCT_NAME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "UninstallString" '"$INSTDIR\uninstall.exe"'

SectionEnd

Section "ASPI Driver" SecASPI

  SetOverwrite ifnewer

  InstPlug::GetSysType
  Pop $0
  StrCmp $0 "NT" winnt

win9x:
  SetOutPath $SYSDIR
  File "aspi_9x\WNASPI32.DLL"
  File "aspi_9x\ASPIENUM.VXD"
  SetOutPath "$SYSDIR\IOSUBSYS"
  File "aspi_9x\APIX.VXD"
  WriteRegStr HKLM "System\CurrentControlSet\Services\VxD\APIX" "ExcludeMiniports" ""
  WriteRegDWORD HKLM "System\CurrentControlSet\Services\VxD\ASPIENUM" "Start" 00000000
  WriteRegStr HKLM "System\CurrentControlSet\Services\VxD\ASPIENUM" "StaticVxD" "ASPIENUM.VXD"
  SetRebootFlag true
  Return

winnt:

SectionEnd

Section "XPAutoPlay" SecXPAutoPlay

  InstPlug::IsXPorNewer
  Pop $0
  StrCmp $0 "NO" done

  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlers\PlayCDAudioOnArrival" "EZMP3CRipCDAudioOnArrival" ""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\EZMP3CRipCDAudioOnArrival" "Action" "$(XPAutoPlayDescription)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\EZMP3CRipCDAudioOnArrival" "DefaultIcon" "$INSTDIR\ezmp3c.exe,0"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\EZMP3CRipCDAudioOnArrival" "InvokeProgID" "EZMP3C.RipCD"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\EZMP3CRipCDAudioOnArrival" "InvokeVerb" "Rip"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\EZMP3CRipCDAudioOnArrival" "Provider" "${PRODUCT_NAME}"
  WriteRegStr HKLM "Software\Classes\EZMP3C.RipCD\shell\Rip" "" "$(XPAutoPlayDescription)"
  WriteRegStr HKLM "Software\Classes\EZMP3C.RipCD\shell\Rip\command" "" "$INSTDIR\ezmp3c.exe /Drive:%L"

done:

SectionEnd

Section "Shortcuts" SecShortcuts

  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application

  SetOutPath $INSTDIR
  CreateDirectory "$SMPROGRAMS\$STARTMENU_FOLDER"
  CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\${PRODUCT_NAME}.lnk" "$INSTDIR\ezmp3c.exe"
  CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\${PRODUCT_NAME} $(HelpStr).lnk" "$INSTDIR\$(HelpFile)"
  CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\$(UninstallStr) ${PRODUCT_NAME}.lnk" "$INSTDIR\uninstall.exe"
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\ezmp3c.exe"

  !insertmacro MUI_STARTMENU_WRITE_END

SectionEnd

Section "WMA Distribution"

  InstPlug::GetSysType
  Pop $0
  StrCmp $0 "9X" install

  ;NT Series
  UserInfo::GetAccountType
  Pop $0
  StrCmp $0 "Admin" install

  ;Not Administrator
  InstPlug::IsWMAInstalled
  Pop $0
  StrCmp $0 "YES" done
  Goto nonadmin

install:
  SetOutPath $TEMP
  File wmaudioredist.exe
  ExecWait "$TEMP\wmaudioredist.exe /Q"
  Delete $TEMP\wmaudioredist.exe
  Goto done

nonadmin:
  MessageBox MB_OK|MB_ICONEXCLAMATION "$(WMAPriviilegePrompt)"

done:

SectionEnd

;--------------------------------
; Uninstaller Section

Section "Uninstall"

  Delete "$INSTDIR\languages\Albanian.lng"
  Delete "$INSTDIR\languages\Arabic.lng"
  Delete "$INSTDIR\languages\Bosnian.lng"
  Delete "$INSTDIR\languages\Bulgarian.lng"
  Delete "$INSTDIR\languages\Catalan.lng"
  Delete "$INSTDIR\languages\Chinese (Simplified).lng"
  Delete "$INSTDIR\languages\Chinese (Traditional).lng"
  Delete "$INSTDIR\languages\Czech.lng"
  Delete "$INSTDIR\languages\Danish.lng"
  Delete "$INSTDIR\languages\Dutch.lng"
  Delete "$INSTDIR\languages\English.lng"
  Delete "$INSTDIR\languages\Estonian.lng"
  Delete "$INSTDIR\languages\Farsi.lng"
  Delete "$INSTDIR\languages\Finnish.lng"
  Delete "$INSTDIR\languages\French.lng"
  Delete "$INSTDIR\languages\Gaelic.lng"
  Delete "$INSTDIR\languages\German.lng"
  Delete "$INSTDIR\languages\Greek.lng"
  Delete "$INSTDIR\languages\Hebrew (New).lng"
  Delete "$INSTDIR\languages\Hebrew.lng"
  Delete "$INSTDIR\languages\Hungarian.lng"
  Delete "$INSTDIR\languages\Indonesian.lng"
  Delete "$INSTDIR\languages\Italian.lng"
  Delete "$INSTDIR\languages\Korean.lng"
  Delete "$INSTDIR\languages\Latvian.lng"
  Delete "$INSTDIR\languages\Lithuanian.lng"
  Delete "$INSTDIR\languages\Norwegian.lng"
  Delete "$INSTDIR\languages\Polish.lng"
  Delete "$INSTDIR\languages\Portuguese (Brazil).lng"
  Delete "$INSTDIR\languages\Portuguese.lng"
  Delete "$INSTDIR\languages\Romanian (New).lng"
  Delete "$INSTDIR\languages\Romanian.lng"
  Delete "$INSTDIR\languages\Russian (New).lng"
  Delete "$INSTDIR\languages\Russian.lng"
  Delete "$INSTDIR\languages\Serbian.lng"
  Delete "$INSTDIR\languages\Slovenian.lng"
  Delete "$INSTDIR\languages\Spanish.lng"
  Delete "$INSTDIR\languages\Swedish.lng"
  Delete "$INSTDIR\languages\Thai.lng"
  Delete "$INSTDIR\languages\Turkish.lng"
  Delete "$INSTDIR\languages\Ukrainian.lng"
  Delete "$INSTDIR\languages\Vietnamese.lng"

  Delete "$INSTDIR\ezmp3c.exe"
  Delete "$INSTDIR\ezmp3c.chm"
  Delete "$INSTDIR\ezmp3c.zhcn.chm"
  Delete "$INSTDIR\ezmp3c.es.chm"
  Delete "$INSTDIR\ezutils.dll"
  Delete "$INSTDIR\akrip32.dll"
  Delete "$INSTDIR\gogo.dll"
  Delete "$INSTDIR\libogg-0.dll"
  Delete "$INSTDIR\libvorbis-0.dll"
  Delete "$INSTDIR\libvorbisenc-2.dll"
  Delete "$INSTDIR\wmaenc.dll"
  Delete "$INSTDIR\COPYING"
  Delete "$INSTDIR\uninstall.exe"

  RMDir "$INSTDIR\languages"
  RMDir "$INSTDIR"

  ;Delete Shortcuts
  !insertmacro MUI_STARTMENU_GETFOLDER Application $MUI_TEMP
  Delete "$SMPROGRAMS\$MUI_TEMP\${PRODUCT_NAME}.lnk"
  Delete "$SMPROGRAMS\$MUI_TEMP\${PRODUCT_NAME} Help.lnk"
  Delete "$SMPROGRAMS\$MUI_TEMP\${PRODUCT_NAME} 帮助.lnk"
  Delete "$SMPROGRAMS\$MUI_TEMP\Uninstall ${PRODUCT_NAME}.lnk"
  Delete "$SMPROGRAMS\$MUI_TEMP\卸载 ${PRODUCT_NAME}.lnk"
  RMDir "$SMPROGRAMS\$MUI_TEMP"
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"

  ;Delete Empty Start Menu Parent Diretories
  ClearErrors
  StrCpy $MUI_TEMP "$SMPROGRAMS\$MUI_TEMP"
start_menu_delete_loop:
  RMDir $MUI_TEMP
  GetFullPathName $MUI_TEMP "$MUI_TEMP\.."
  IfErrors start_menu_delete_loop_done
  StrCmp $MUI_TEMP $SMPROGRAMS start_menu_delete_loop_done start_menu_delete_loop
start_menu_delete_loop_done:

  ;Remove Install Registry Keys
  DeleteRegValue HKCU "Software\${COMPANY_NAME}\${PRODUCT_NAME}" ""
  DeleteRegValue HKCU "Software\${COMPANY_NAME}\${PRODUCT_NAME}" "Installer Language"
  DeleteRegValue HKCU "Software\${COMPANY_NAME}\${PRODUCT_NAME}" "Start Menu Folder"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"

  ;Remove Program Registry Keys
  MessageBox MB_YESNO "$(KeepConfigurationPrompt)" IDNO registry_delete_all
  DeleteRegKey /ifempty HKCU "Software\${COMPANY_NAME}\${PRODUCT_NAME}"
  Goto registry_delete_done
registry_delete_all:
  DeleteRegKey HKCU "Software\${COMPANY_NAME}\${PRODUCT_NAME}"
registry_delete_done:

  ;Remove Company Registry Keys
  DeleteRegKey /ifempty HKCU "Software\${COMPANY_NAME}"

  ;Uninstall AutoPlay Handler for Windows XP
  InstPlug::IsXPorNewer
  Pop $0
  StrCmp $0 "NO" xp_autoplay_uninstall_done
  DeleteRegValue HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlers\PlayCDAudioOnArrival" "EZMP3CRipCDAudioOnArrival"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers\EZMP3CRipCDAudioOnArrival"
  DeleteRegKey HKLM "Software\Classes\EZMP3C.RipCD\shell\Rip"
xp_autoplay_uninstall_done:

SectionEnd

!macro ChangeShellContext
  UserInfo::GetAccountType
    Pop $0
  StrCmp $0 "Admin" 0 +2
  SetShellVarContext all
!macroend

Function .onInit
  !insertmacro ChangeShellContext
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Function un.onInit
  !insertmacro ChangeShellContext
  !insertmacro MUI_UNGETLANGUAGE
FunctionEnd
