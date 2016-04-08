* Francis FAURE
* Generate an extension for VS Code which provides support for the Visual FoxPro language
* January 2016
* VS Code URL : https://code.visualstudio.com/
* April 2016 : snippets added
clear
set exact on
set textmerge delimiters

#define C_CRLF chr(13) + chr(10)
#define C_TAB  chr(9)

#define C_LANGUAGE                         "vfp"
#define C_TMLANGUAGE_FILENAME              "vfp.tmLanguage"
#define C_PACKAGE_JSON_FILENAME            "package.json"
#define C_CONFIGURATION_JSON_FILENAME      "vfp.configuration.json"
#define C_SNIPPETS_JSON_FILENAME           "vfp.snippets.json"
#define C_UNINSTALL_FILENAME               "uninstall vfp language.cmd"
#define C_INSTALL_FILENAME                 "install vfp language.cmd"
#define C_OUTPUT_DIR                       addbs(justpath(sys(16,0))) + "vfp_tmlanguage\"
#define C_MESSAGEBOX_TITLE                 "(VS Code) Visual FoxPro language"
* 0.1.0 Initial Commit
* 0.1.1 Snippets added
#define C_VERSION                          "0.1.1"

*** -------------- TextMate String ---------------------------
#define C_TM_NAME_COMMENTS     "comment." + C_LANGUAGE
#define C_TM_NAME_CONSTANTS    "constant.language." + C_LANGUAGE && constant.language, support.constant
#define C_TM_NAME_OPERATORS    "keyword.operator." + C_LANGUAGE
#define C_TM_NAME_STRING1      "string.quoted.single." + C_LANGUAGE
#define C_TM_NAME_STRING2      "string.quoted.double." + C_LANGUAGE
#define C_TM_NAME_STRING3      "string.quoted.triple." + C_LANGUAGE
#define C_TM_NAME_STRING4      "string.interpolated." + C_LANGUAGE
#define C_TM_NAME_NUMERICS     "constant.numeric." + C_LANGUAGE
#define C_TM_NAME_COMMANDS     "support.other." + C_LANGUAGE    && tm type ? storage.type, support.other, keyword
#define C_TM_NAME_PREPROCESSOR_DIRECTIVES "meta.preprocessor." + C_LANGUAGE && tm type ? support.constant, meta.preprocessor
#define C_TM_NAME_FUNCTIONS    "support.function." + C_LANGUAGE && support.function, entity.name.function, storage.type, meta.function
#define C_TM_NAME_BASECLASSES  "support.class." + C_LANGUAGE    && support.class, entity.other.inherited-class, entity.name.type
#define C_TM_NAME_TYPES        "support.type." + C_LANGUAGE
#define C_TM_NAME_PEM          "keyword." + C_LANGUAGE && keyword, support.function
#define C_TM_NAME_SYSTEM_VARIABLES "variable.language." + C_LANGUAGE && variable.language, support.variable, constant.character
#define C_TM_NAME_VARIABLES    "variable.other." + C_LANGUAGE
#define C_TM_NAME_ARRAYS       "variable.other." + C_LANGUAGE
#define C_TM_NAME_TOKENS       "keyword." + C_LANGUAGE && keyword, support.other or C_TM_NAME_COMMANDS ?

#define C_DEBUG_GENERATE_TMTHEME_TEST .f.


local lsxml as string
lsxml = ""

*** -------------- TMTHEME TESTS (for debug)  ----------------------------------
#if C_DEBUG_GENERATE_TMTHEME_TEST
  lsxml = m.lsxml + xml_TMTHEME()
#endif

*** -------------- COMMENTS ----------------------------------
#define COMMENTS
lsxml = m.lsxml + xml_comment("COMMENTS")  && NOTE / * / &&
lsxml = m.lsxml + xml_Match_Name("(^[ |\t]*(?i:note)\s.*|^[ |\t]*\*.*|&amp;&amp;.*)", C_TM_NAME_COMMENTS)

*** -------------- CONSTANTS ----------------------------------
#define CONSTANTS
lsxml = m.lsxml + xml_comment("CONSTANTS")
lsxml = m.lsxml + xml_Match_Name("(?i:(\.t\.|\.y\.|\.f\.|\.n\.|\.null\.|\bnull\b))", C_TM_NAME_CONSTANTS)

*** -------------- PREPROCESSOR DIRECTIVES ----------------------------------
#define PREPROCESSOR_DIRECTIVES
lsxml = m.lsxml + xml_comment("PREPROCESSOR DIRECTIVES")
dimension laxml[11]
laxml=""
laxml[ 1] = "define"
laxml[ 2] = "undefine"
laxml[ 3] = "ifdef"
laxml[ 4] = "ifndef"
laxml[ 5] = "include"
laxml[ 6] = "if"
laxml[ 7] = "elif"
laxml[ 8] = "else"
laxml[ 9] = "endif"
laxml[10] = "name"
laxml[11] = "insert"
sxml = ""
for i=1 to alen(m.laxml)
  sxml = m.sxml + iif(empty(m.sxml),"","|") + split(m.laxml[m.i])
next
lsxml = m.lsxml + xml_Match_Name("^[ |\t]*#[ |\t]*(?i:("+m.sxml+")\b)", C_TM_NAME_PREPROCESSOR_DIRECTIVES)


*** -------------- COMMANDS ----------------------------------
#define COMMANDS
lsxml=m.lsxml + xml_comment("COMMANDS")
dimension laxml[11]
laxml=""
n=alanguage(laCommands, 1)
* particulars cases
* DIMENSION laCommands[ALEN(laCommands)+1]
* laCommands[ALEN(laCommands)]="missing"

for i=1 to m.n
  sf=lower(m.laCommands[m.i])
  if !isalpha(left(m.sf,1)) or ;
      inlist(m.sf,"note","include","name","ifdef","elif","undefine") && particulars cases
    ? "Command ignored:" + m.sf && name are not in array commands
    loop
  endif
  ilen=len(m.sf)
  sxml = split(m.sf)
  laxml[m.iLen] = iif(empty(m.laxml[m.iLen]), m.sxml, m.laxml[m.iLen] + "|" + m.sxml)
next
for i=1 to 11
  lsxml=m.lsxml+xml_Commands(m.laxml[m.i])
next
* add particulars cases
lsxml=m.lsxml + xml_Match_Name("^[ |\t]*(!|=|\?\?\?|\?\?|\?|@|\\\\|\\)", C_TM_NAME_COMMANDS)

*** -------------- FUNCTIONS ----------------------------------
#define FUNCTIONS
lsxml = m.lsxml + xml_comment("FUNCTIONS")
dimension laxml[17]
laxml = ""
n=alanguage(laFunctions, 2)
* particulars cases
* n=n+1
* DIMENSION laFunctions[m.n, 2]
* laFunctions[m.n, 1] = "missing"
* laFunctions[m.n, 2] = "M"
* =ASORT(laFunctions, 1)

for i=1 to m.n
  sf = lower(m.laFunctions[m.i,1])
  ilen = len(m.sf)
  lfull = left(m.laFunctions[m.i,2],1) == "M"
  sxml = split(m.sf, m.lfull)
  laxml[m.iLen] = iif(empty(m.laxml[m.iLen]), m.sxml, m.laxml[m.iLen] + "|" + m.sxml)
next
for i=1 to 17
  lsxml = m.lsxml + xml_Functions(m.laxml[m.i])
next

*** -------------- BASE CLASSES ----------------------------------
#define BASE_CLASSES
lsxml = m.lsxml + xml_comment("BASE CLASSES")
dimension laxml[44]
laxml=""
n = alanguage(laClasses, 3)
sxml=""
for i=1 to m.n
  sf = lower(m.laClasses[m.i])
  sxml = m.sxml + iif(empty(m.sxml), "", "|") + m.sf
next
sxml = "(?i:(" + m.sxml+ "))"
lsxml = m.lsxml + xml_Match_Name(["] + m.sxml + ["], C_TM_NAME_BASECLASSES)
lsxml = m.lsxml + xml_Match_Name(['] + m.sxml + ['], C_TM_NAME_BASECLASSES)
lsxml = m.lsxml + xml_Match_Name("\[" + m.sxml+ "\]", C_TM_NAME_BASECLASSES) && todo
lsxml = m.lsxml + xml_Match_Name("\b " + m.sxml+ "\b", C_TM_NAME_BASECLASSES)

*** -------------- PEM ----------------------------------
#define PEM
lsxml = m.lsxml + xml_comment("PEM - Properties Events Methods")
dimension aPEM[1]
aPEM[1] = "init"
for nBC=1 to alen(laClasses)
  ClassName = m.laClasses[m.nBC]
  nPEM = amembers(lArray, m.ClassName, 1)
  for i=1 to m.nPEM
    cPEM = lower(m.lArray[m.i, 1])
    if ascan(m.aPEM, m.cPEM, -1, -1, 1, 7) == 0
      dimension aPEM[ALEN(m.aPEM)+1]
      aPEM[ALEN(m.aPEM)] = m.cPEM
    endif
  next
next
=asort(m.aPEM)
sxml=""
for i=1 to alen(m.aPEM)
  sxml=m.sxml + iif(m.i==1,"","|") + aPEM[m.i]
next
lsxml=m.lsxml + xml_Match_Name("(?i:\b(" + m.sxml+ ")\b)", C_TM_NAME_PEM)

*** -------------- TYPES ----------------------------------
#define TYPES
lsxml = m.lsxml + xml_comment("TYPES")
lsTypes = "array|binary|blob|boolean|byte|character|currency|date|datetime|decimal|double|float|general|integer|logical|long|memo|number|numeric|object|short|single|string|varbinary|varchar|variant|void"
lsxml = m.lsxml + xml_Match_Name("(?i:\b(" + m.lsTypes + ")\b)", C_TM_NAME_TYPES)

*** -------------- OTHER TOKENS ----------------------------------
#define TOKENS
lsxml=m.lsxml + xml_comment("OTHER TOKENS")
select token ;
  from home() + "wizards\fdkeywrd.dbf" ;
  where alltrim(code) == "C" and left(token,1)!="/" ;
  into array aToken
use in fdkeywrd
* particulars cases
dimension aToken[ALEN(aToken)+1]
aToken[ALEN(aToken)] = "on"
dimension aToken[ALEN(aToken)+1]
aToken[ALEN(aToken)] = "with"
dimension aToken[ALEN(aToken)+1]
aToken[ALEN(aToken)] = "strictdate"
dimension aToken[ALEN(aToken)+1]
aToken[ALEN(aToken)] = "while"
*
=asort(aToken)
sxml = ""
for i=1 to alen(aToken)
  aToken[m.i] = lower(alltrim(aToken[m.i]))
  * particulars cases
  if inlist(aToken[m.i],"or","and","not") or ;
      ("|"+aToken[m.i]+"|")$("|"+m.lsTypes+"|")
    ? "Token ignored: '" + m.aToken[m.i] + "' (->Type)"
  else
    sxml = m.sxml + iif(m.i==1,"","|") + split(aToken[m.i])
  endif
next
lsxml = m.lsxml + xml_Match_Name("(?i:\b(" + m.sxml + ")\b)", C_TM_NAME_TOKENS)


*** -------------- SYSTEM VARIABLES ----------------------------------
#define SYSTEM_VARIABLES
lsxml = m.lsxml + xml_comment("SYSTEM VARIABLES")
select token ;
  from home() + "wizards\fdkeywrd.dbf" ;
  where left(token,1)=="_" and empty(code);
  into array aSystemVariables
use in fdkeywrd

for i=1 to alen(m.aSystemVariables)
  aSystemVariables[m.i] = lower(alltrim(m.aSystemVariables[m.i]))
  if type(m.aSystemVariables[m.i])=="U"
    ? aSystemVariables[m.i] + " unknown"
    aSystemVariables[m.i] = ""
  endif
next
=asort(m.aSystemVariables)

* particulars cases
dimension aSystemVariables[ALEN(m.aSystemVariables)+1]
aSystemVariables[ALEN(m.aSystemVariables)] = "this"
dimension aSystemVariables[ALEN(m.aSystemVariables)+1]
aSystemVariables[ALEN(m.aSystemVariables)] = "thisform"
dimension aSystemVariables[ALEN(m.aSystemVariables)+1]
aSystemVariables[ALEN(m.aSystemVariables)] = "thisformset"
*
sxml = ""
for i=1 to alen(m.aSystemVariables)
  if !empty(m.aSystemVariables[m.i])
    sxml = m.sxml + iif(empty(m.sxml),"","|") + m.aSystemVariables[m.i]
  endif
next
lsxml = m.lsxml + xml_Match_Name("(?i:\b(" + m.sxml + ")\b)", C_TM_NAME_SYSTEM_VARIABLES)

*** -------------- ARRAYS (before STRING for [String] ) ----------------------------------
#define ARRAYS
lsxml = m.lsxml + xml_comment("ARRAYS")  && '' / "" / [}
lsxml = m.lsxml + xml_Match_Captures("(\b(?i:m\.)?[A-Za-z_]\w*[ |\t]*)(\[)", "1", C_TM_NAME_ARRAYS)

*** -------------- STRINGS ----------------------------------
#define STRINGS
lsxml = m.lsxml + xml_comment("STRINGS")  && '' / "" / [}
lsxml = m.lsxml + xml_Match_Name("'[^']*'", C_TM_NAME_STRING1)
lsxml = m.lsxml + xml_Match_Name('"[^"]*"', C_TM_NAME_STRING2)
lsxml = m.lsxml + xml_Match_Name("\[[^\]]*\]", C_TM_NAME_STRING3)
lsxml = m.lsxml + xml_Match_Name("&amp;\w*", C_TM_NAME_STRING4)

*** -------------- VARIABLES & OPERATORS ----------------------------------
* 2016.03.12
local lsRegExpOperators as string
lsRegExpOperators = "(?i:(\+|-|\*|/|%|\^|\*\*|\$|==|=|&lt;|&lt;=|&gt;|&gt;=|&lt;&gt;|#|!=|!|" + ;
  "\.or\.|\.and\.|\.not\.|"+;
  "\bor\b|\band\b|\bnot\b))"

*** -------------- VARIABLES (After ARRAYS and Before Operators) ----------------------------------
#define VARIABLES
lsxml = m.lsxml + xml_comment("VARIABLES")
* m dot var
lsxml = m.lsxml + xml_Match_Name("\b(?i:m\.)[A-Za-z_]\w*\b", C_TM_NAME_VARIABLES)
local lsVar1 as string
lsVar1 = "(\b[A-Za-z_]\w*[ |\t]*)"
local lsVar2 as string
lsVar2 = "([ |\t]*(?i:m\.)?[A-Za-z_]\w*)"
* at end : all Names following Operator -> Variable
lsxml = m.lsxml + xml_Match_Captures(m.lsVar1 + "?" + ;
  m.lsRegExpOperators + ;
  m.lsVar2 + ;
  "(\s|,|;|\))", ;
  "1", C_TM_NAME_VARIABLES, ;
  "2", C_TM_NAME_OPERATORS, ;
  "3", C_TM_NAME_VARIABLES)
* at end : all Operators following Name -> Variable
lsxml=m.lsxml + xml_Match_Captures(m.lsVar1 + m.lsRegExpOperators, ;
  "1", C_TM_NAME_VARIABLES,;
  "2", C_TM_NAME_OPERATORS)

*** -------------- OPERATORS ----------------------------------
#define OPERATORS
lsxml = m.lsxml + xml_comment("OPERATORS")
* 2016.03.12
* lsxml=m.lsxml + xml_Match_Name("(\+|-|\*|/|%|\^|\*\*|\$|==|=|&lt;|&lt;=|&gt;|&gt;=|&lt;&gt;|#|!=|!)", C_TM_NAME_OPERATORS)
* lsxml=m.lsxml + xml_Match_Name("(?i:(\.or\.|\.and\.|\.not\.))", C_TM_NAME_OPERATORS)
* lsxml=m.lsxml + xml_Match_Name("(?i:\b(or|and|not)\b)", C_TM_NAME_OPERATORS)
lsxml = m.lsxml + xml_Match_Name(m.lsRegExpOperators, C_TM_NAME_OPERATORS)


*** -------------- NUMERICS ----------------------------------
#define NUMERICS
lsxml = m.lsxml + xml_comment("NUMERICS")
lsxml = m.lsxml + xml_Match_Name("\b(0(x|X|h|H)[0-9a-fA-F]*)\b", C_TM_NAME_NUMERICS) && Hexa / VarBinary
lsxml = m.lsxml + xml_Match_Name("(\$( |\t)*-?\d+(\.?\d*)?)\b", C_TM_NAME_NUMERICS) && Currency
lsxml = m.lsxml + xml_Match_Name("\b(\d+(\.?\d*)?(e(\+|-)?\d*)?)\b", C_TM_NAME_NUMERICS) && numerique / Float

*** -------------- PATTERNS ----------------------------------
#define PATTERNS
lsxml = xml_Patterns(m.lsxml)

*** -------------- HEADER + FOOTER ----------------------------------
#define HEADER_FOOTER
lsxml = xml_Header_Footer(m.lsxml)


*** BUILD EXTENSION
#define BUILD_EXTENSION
lsxml = utf8(m.lsxml)
if CreateFile(C_TMLANGUAGE_FILENAME, m.lsxml) and ;
    CreateFile(C_PACKAGE_JSON_FILENAME, package_json()) and ;
    CreateFile(C_CONFIGURATION_JSON_FILENAME, configuration_json()) and ;
    CreateFile(C_SNIPPETS_JSON_FILENAME, snippets_json()) and ;
    CreateFile(C_INSTALL_FILENAME, install_script()) and ;
    CreateFile(C_UNINSTALL_FILENAME, uninstall_script())
  ? "DONE"
  if install()
    if run_vscode_test()
    else
      =messagebox("OK : Restart your VS Code !", 0, C_MESSAGEBOX_TITLE)
    endif
  endif
endif

return


function split(lsString as string, llfull as Logical) as string
  local lsreturn as string
  lsreturn=""
  do case
    case len(m.lsString)<=4 or m.llfull
      lsreturn = m.lsString
    case len(m.lsString)==5
      lsreturn = left(m.lsString, 4)+"["+substr(m.lsString,5,1)+"]?"
    otherwise
      local i
      lsreturn = left(m.lsString, 4) + "(?:"
      for i=5 to len(m.lsString)
        lsreturn = m.lsreturn + iif(m.i>5,"|","") + substr(m.lsString, 5, m.i-4)
      next
      lsreturn = m.lsreturn + ")?"
  endcase
  return m.lsreturn
endfunc


function xml_Commands(lsString as string) as string
  if empty(m.lsString)
    return ""
  else
    * VFP colorize all commands words anywhere
    *    lsreturn=m.lsreturn+"(?i:\b(" + m.lsString +")\b)" && \s ?
    * we can colorize only commands at begining of lines
    return xml_Match_Name("^[ |\t]*(?i:(" + m.lsString +")\b)", C_TM_NAME_COMMANDS)
  endif
endfunc

function xml_Functions(lsString as string) as string
  if empty(m.lsString)
    return ""
  else
    return xml_Match_Captures("(?i:\b(" + m.lsString +")( |\t)*(\(|\[))", "1", C_TM_NAME_FUNCTIONS)
  endif
endfunc

function xml_Patterns(lsString as string) as string
  lsString = ;
    C_TAB+"<key>patterns</key>" + C_CRLF+ ;
    C_TAB+"<array>" + C_CRLF+ ;
    m.lsString + ;
    C_TAB+"</array>" + C_CRLF
  return m.lsString
endfunc

function xml_Header_Footer(lsString as string) as string
  * header
  lsString = ;
    [<?xml version="1.0" encoding="UTF-8"?>] + C_CRLF + ;
    [<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">] + C_CRLF + ;
    [<plist version="1.0">] + C_CRLF + ;
    "<dict>" + C_CRLF + ;
    C_TAB + "<key>fileTypes</key>" + C_CRLF + ;
    C_TAB + "<array>" + C_CRLF + ;
    C_TAB + C_TAB + "<string>prg</string>" + C_CRLF + ;
    C_TAB + "</array>" + C_CRLF + ;
    C_TAB + "<key>name</key>" + C_CRLF + ;
    C_TAB + +"<string>Visual FoxPro</string>" + C_CRLF + ;
    m.lsString
  * footer
  lsString = m.lsString + ;
    C_TAB + "<key>scopeName</key>" + C_CRLF + ;
    C_TAB + "<string>source." + C_LANGUAGE + "</string>" + C_CRLF + ;
    C_TAB + "<key>uuid</key>" + C_CRLF + ;
    C_TAB + "<string>8DE7EBCD-DBDB-47F5-A9A3-1276BB82C3F4</string>" + C_CRLF + ;
    "</dict>" + C_CRLF + ;
    "</plist>" + C_CRLF
  return m.lsString
endfunc

function xml_comment(lsString as string) as string
  return C_CRLF + replicate(C_TAB, 2) + "<!-- " + alltrim(m.lsString) + "-->" + C_CRLF
endfunc

function xml_Match_Name(lsMatch as string, lsName as string) as string
  local lsreturn
  lsreturn=""
  if !empty(m.lsMatch)
    lsreturn = m.lsreturn + replicate(C_TAB,2) + "<dict>"+C_CRLF
    lsreturn = m.lsreturn + replicate(C_TAB,3) + "<key>match</key>" + C_CRLF
    lsreturn = m.lsreturn + replicate(C_TAB,3) + "<string>" + m.lsMatch+"</string>" + C_CRLF
    lsreturn = m.lsreturn + replicate(C_TAB,3) + "<key>name</key>"+C_CRLF
    lsreturn = m.lsreturn + replicate(C_TAB,3) + "<string>" + m.lsName+"</string>" + C_CRLF
    lsreturn = m.lsreturn + replicate(C_TAB,2) + "</dict>" + C_CRLF
  endif
  return m.lsreturn
endfunc

function xml_Match_Captures(lsMatch as string, ;
    lsKey1 as string, lsName1 as string, ;
    lsKey2 as string, lsName2 as string, ;
    lsKey3 as string, lsName3 as string) as string
  local lsreturn
  lsreturn = ""
  if !empty(m.lsMatch)
    lsreturn = m.lsreturn + replicate(C_TAB,2)+"<dict>"+C_CRLF
    lsreturn = m.lsreturn + replicate(C_TAB,3)+"<key>captures</key>"+C_CRLF
    lsreturn = m.lsreturn + replicate(C_TAB,3)+"<dict>"+C_CRLF
    * key1
    lsreturn = m.lsreturn + replicate(C_TAB,4)+"<key>" + m.lsKey1+ "</key>"+C_CRLF
    lsreturn = m.lsreturn + replicate(C_TAB,4)+"<dict>"+C_CRLF
    lsreturn = m.lsreturn + replicate(C_TAB,5)+"<key>name</key>"+C_CRLF
    lsreturn = m.lsreturn + replicate(C_TAB,5)+"<string>"+m.lsName1+"</string>"+C_CRLF
    lsreturn = m.lsreturn + replicate(C_TAB,4)+"</dict>"+C_CRLF
    * key2
    if !empty(m.lsKey2)
      lsreturn = m.lsreturn + replicate(C_TAB,4)+"<key>" + m.lsKey2 + "</key>" + C_CRLF
      lsreturn = m.lsreturn + replicate(C_TAB,4)+"<dict>" + C_CRLF
      lsreturn = m.lsreturn + replicate(C_TAB,5)+"<key>name</key>" + C_CRLF
      lsreturn = m.lsreturn + replicate(C_TAB,5)+"<string>" + m.lsName2 + "</string>" + C_CRLF
      lsreturn = m.lsreturn + replicate(C_TAB,4)+"</dict>" + C_CRLF
    endif
    * key3
    if !empty(m.lsKey3)
      lsreturn = m.lsreturn + replicate(C_TAB,4)+"<key>" + m.lsKey3 + "</key>" + C_CRLF
      lsreturn = m.lsreturn + replicate(C_TAB,4)+"<dict>" + C_CRLF
      lsreturn = m.lsreturn + replicate(C_TAB,5)+"<key>name</key>" + C_CRLF
      lsreturn = m.lsreturn + replicate(C_TAB,5)+"<string>" + m.lsName3 + "</string>" + C_CRLF
      lsreturn = m.lsreturn + replicate(C_TAB,4)+"</dict>" + C_CRLF
    endif
    *
    lsreturn = m.lsreturn + replicate(C_TAB,3)+"</dict>"+C_CRLF
    lsreturn = m.lsreturn + replicate(C_TAB,3)+"<key>match</key>"+C_CRLF
    lsreturn = m.lsreturn + replicate(C_TAB,3)+"<string>"+m.lsMatch+"</string>"+C_CRLF
    lsreturn = m.lsreturn + replicate(C_TAB,2)+"</dict>"+C_CRLF
  endif
  return m.lsreturn
endfunc

*** -------------- TMTHEME TESTS (debug)  ----------------------------------
#if C_DEBUG_GENERATE_TMTHEME_TEST

function xml_TMTHEME() as string
  local lsreturn as string
  lsreturn = ""
  * http://manual.macromates.com/en/language_grammars
  lsreturn = m.lsreturn + xml_comment("tmTheme tests")
  dimension laxml[66]
  laxml=""
  laxml[ 1] = "comment.line"
  laxml[ 2] = "comment.block"
  laxml[ 3] = "comment"
  laxml[ 4] = "constant.numeric"
  laxml[ 5] = "constant.character"
  laxml[ 6] = "constant.language"
  laxml[ 7] = "constant.other"
  laxml[ 8] = "constant"
  laxml[09] = "entity.name.function"
  laxml[10] = "entity.name.type"
  laxml[11] = "entity.name.tag"
  laxml[12] = "entity.name.section"
  laxml[13] = "entity.name"
  laxml[14] = "entity.other.section"
  laxml[15] = "entity.other.inherited-class"
  laxml[16] = "entity.other.attribute-name"
  laxml[17] = "entity.other"
  laxml[18] = "entity"
  laxml[19] = "invalid.illegal"
  laxml[20] = "invalid.deprecated"
  laxml[21] = "invalid"
  laxml[22] = "keyword.control"
  laxml[23] = "keyword.operator"
  laxml[24] = "keyword.other"
  laxml[25] = "keyword"
  laxml[26] = "markup.underline.link"
  laxml[27] = "markup.underline"
  laxml[28] = "markup.bold"
  laxml[29] = "markup.heading.1"
  laxml[30] = "markup.heading.2"
  laxml[31] = "markup.heading.3"
  laxml[32] = "markup.heading"
  laxml[33] = "markup.italic"
  laxml[34] = "markup.list.numbered"
  laxml[35] = "markup.list.unnumbered"
  laxml[36] = "markup.list"
  laxml[37] = "markup.quote"
  laxml[38] = "markup.raw"
  laxml[39] = "markup.other"
  laxml[40] = "markup"
  laxml[41] = "meta.preprocessor"
  laxml[42] = "meta"
  laxml[43] = "storage.type"
  laxml[44] = "storage.modifier"
  laxml[45] = "storage"
  laxml[46] = "string.quoted.single"
  laxml[47] = "string.quoted.double"
  laxml[48] = "string.quoted.triple"
  laxml[49] = "string.quoted.other"
  laxml[50] = "string.quoted"
  laxml[51] = "string.unquoted"
  laxml[52] = "string.interpolated"
  laxml[53] = "string.regexp"
  laxml[54] = "string.other"
  laxml[55] = "string"
  laxml[56] = "support.function"
  laxml[57] = "support.class"
  laxml[58] = "support.type"
  laxml[59] = "support.constant"
  laxml[60] = "support.variable"
  laxml[61] = "support.other"
  laxml[62] = "support"
  laxml[63] = "variable.parameter"
  laxml[64] = "variable.language"
  laxml[65] = "variable.other"
  laxml[66] = "variable"
  for m.i = 1 to alen(m.laxml)
    lsreturn = m.lsreturn + xml_tmThemeTest(laxml[m.i])
  next
  lsreturn = m.lsreturn + "<!-- " + C_CRLF
  for i=1 to alen(laxml)
    lsreturn = m.lsreturn + "*- " + laxml[m.i] + C_CRLF
  next
  lsreturn = m.lsreturn + "-->" + C_CRLF
  return m.lsreturn
endfunc

function xml_tmThemeTest(lsString as string) as string
  if empty(m.lsString)
    return ""
  else
    return xml_Match_Name("(?i:\*- " + strtran(m.lsString, ".", "\.") + "\b)", m.lsString)
  endif
endfunc
#endif


function CreateFile(lsFilename as string, lsString as string) as Logical
  local llReturn as Logical
  llReturn=.t.
  try
    if !directory(C_OUTPUT_DIR)
      md C_OUTPUT_DIR
    endif
    =DeleteFileIfExist(C_OUTPUT_DIR + m.lsFilename)
    =strtofile(m.lsString, C_OUTPUT_DIR + m.lsFilename, 0)
    ? "Generate " + C_OUTPUT_DIR + m.lsFilename
  catch
    llReturn=.f.
    ? "ERROR-----------------------"
    ? message()
    cancel
  endtry
  return m.llReturn
endfunc

procedure DeleteFileIfExist(lsFilename as string)
  if file(m.lsFilename)
    erase (m.lsFilename)
  endif
endproc

function utf8(m.lsString as string) as string
  return strconv(strconv(m.lsString, 1),9)
endfunc

function package_json() as string
  local lsreturn as string
  local lsLanguage as string
  lsLanguage = C_LANGUAGE
  local tmLanguage as string
  tmLanguage = C_TMLANGUAGE_FILENAME
  local lsVersion as string
  lsVersion = C_VERSION
  local lsSnippets as string
  lsSnippets = C_SNIPPETS_JSON_FILENAME
  text TO m.lsReturn NOSHOW TEXTMERGE
{
	"name": "<<m.lsLanguage>>",
	"displayName": "Language Visual FoxPro",
	"description": "An extension for VS Code which provides support for the Visual FoxPro language.",
	"version": "<<m.lsVersion>>",
	"publisher": "Francis FAURE",
	"engines": {
		"vscode": "^0.10.1"
	},
	"categories": [
		"Languages"
	],
	"contributes": {
		"languages": [{
			"id": "<<m.lsLanguage>>",
			"aliases": ["Visual FoxPro","Foxpro","FoxPro","foxpro"],
			"extensions": [".prg"],
			"configuration": "./vfp.configuration.json"
		}],
		"grammars": [{
			"language": "<<m.lsLanguage>>",
			"scopeName": "source.<<m.lsLanguage>>",
			"path": "./syntaxes/<<m.tmLanguage>>"
		}],
        "snippets": [
            {
                "language": "vfp",
                "path": "./snippets/<<m.lsSnippets>>"
            }
        ]
	}
}
  ENDTEXT
  return utf8(m.lsreturn)
endfunc

function configuration_json() as string
  local lsreturn as string
  local lsLanguage as string
  lsFile = C_CONFIGURATION_JSON_FILENAME
  text TO m.lsReturn NOSHOW TEXTMERGE
// <<m.lsFile>>
{
}
  ENDTEXT
  return utf8(m.lsreturn)
endfunc

* return .T. if installed
function install() as Logical
  local llReturn as Logical
  llReturn = .f.
  if file(C_OUTPUT_DIR + C_TMLANGUAGE_FILENAME) and ;
      file(C_OUTPUT_DIR + C_PACKAGE_JSON_FILENAME) and ;
      file(C_OUTPUT_DIR + C_CONFIGURATION_JSON_FILENAME) and ;
      file(C_OUTPUT_DIR + C_SNIPPETS_JSON_FILENAME)
    local lsVSCodeExtensionDir as string
    lsVSCodeExtensionDir = getenv("USERPROFILE") + "\.vscode\extensions\"
    if directory(m.lsVSCodeExtensionDir)
      if messagebox("Install now ?", 4+32, C_MESSAGEBOX_TITLE) == 6 && YES
        try
          *!*	          if !directory(m.lsVSCodeExtensionDir)
          *!*	            md (m.lsVSCodeExtensionDir)
          *!*	          endif
          if !directory(m.lsVSCodeExtensionDir + C_LANGUAGE)
            md (m.lsVSCodeExtensionDir + C_LANGUAGE)
          endif
          if !directory(m.lsVSCodeExtensionDir + C_LANGUAGE + "\syntaxes")
            md (m.lsVSCodeExtensionDir + C_LANGUAGE + "\syntaxes")
          endif
          if !directory(m.lsVSCodeExtensionDir + C_LANGUAGE + "\snippets")
            md (m.lsVSCodeExtensionDir + C_LANGUAGE + "\snippets")
          endif

          =DeleteFileIfExist(m.lsVSCodeExtensionDir + C_LANGUAGE + "\syntaxes\" + C_TMLANGUAGE_FILENAME)
          copy file (C_OUTPUT_DIR + C_TMLANGUAGE_FILENAME) to (m.lsVSCodeExtensionDir + C_LANGUAGE + "\syntaxes")

          =DeleteFileIfExist(m.lsVSCodeExtensionDir + C_LANGUAGE + "\snippets\" + C_SNIPPETS_JSON_FILENAME)
          copy file (C_OUTPUT_DIR + C_SNIPPETS_JSON_FILENAME) to (m.lsVSCodeExtensionDir + C_LANGUAGE + "\snippets")

          =DeleteFileIfExist(m.lsVSCodeExtensionDir + C_LANGUAGE + "\" + C_PACKAGE_JSON_FILENAME)
          copy file (C_OUTPUT_DIR + C_PACKAGE_JSON_FILENAME) to (m.lsVSCodeExtensionDir + C_LANGUAGE)

          =DeleteFileIfExist(m.lsVSCodeExtensionDir + C_LANGUAGE + "\" + C_CONFIGURATION_JSON_FILENAME)
          copy file (C_OUTPUT_DIR + C_CONFIGURATION_JSON_FILENAME) to (m.lsVSCodeExtensionDir + C_LANGUAGE)

          llReturn = .t.

        catch
          ? "ERROR-----------------------"
          ? message()
          cancel
        endtry
      endif
    else
      ? "VS Code not installed on this computer (" + m.lsVSCodeExtensionDir + ": not found)"
    endif
  endif
  return m.llReturn
endfunc




function snippets_json() as string
  local lsreturn as string
  local lsLanguage as string
  lsLanguage = C_LANGUAGE
  text TO m.lsReturn NOSHOW TEXTMERGE
{
".source.<<m.lsLanguage>>": {
  <<snippet_json_for()>>,
  <<snippet_json_do_case()>>,
  <<snippet_json_do_while()>>,
  <<snippet_json_try()>>,
  <<snippet_json_function()>>,
  <<snippet_json_scan()>>,
  <<snippet_json_if()>>
  }
}
  ENDTEXT
  return utf8(m.lsreturn)
endfunc


function snippet_json_for()
\\  "foreach": {
\        "prefix": "for",
\        "body": [
\          "for each ${Var} in ${Group} ${FOXOBJECT}",
\          "\t$1* Commands",
\          "\t$2* exit",
\          "\t$3* loop",
\          "next"
\          ],
\        "description": "FOR EACH ... NEXT"
\     },
\  "for": {
\        "prefix": "for",
\        "body": [
\          "for ${VarName} = 1 to ${nFinalValue} step ${nIncrement}",
\          "\t$1* Commands",
\          "\t$2* exit",
\          "\t$3* loop",
\          "next"
\          ],
\        "description": "FOR ... NEXT"
\     }
  return ""
endfunc

function snippet_json_do_case()
\\  "do case": {
\        "prefix": "do",
\        "body": [
\          "do case",
\          "\tcase ${lExpression1}",
\          "\t\t$1* Commands",
\          "\tcase ${lExpression2}",
\          "\t\t$2* Commands",
\          "\tcase ${lExpressionN}",
\          "\t\t$3* Commands",
\          "otherwise",
\          "\t\t$4* Commands",
\          "endcase"
\          ],
\        "description": "DO CASE ... ENDCASE"
\     }
  return ""
endfunc

function snippet_json_do_while()
\\  "do while": {
\        "prefix": "do",
\        "body": [
\          "do while ${lExpression}",
\          "\t$1* Commands ",
\          "\t$2* exit",
\          "\t$3* loop",
\          "enddo"
\          ],
\        "description": "DO WHILE ... ENDDO"
\     }
  return ""
endfunc

function snippet_json_function()
\\  "function": {
\        "prefix": "function",
\        "body": [
\          "function ${FunctionName}(${parameter1} as ${type1}, ${parameter2} as ${type2}) as ${returntype}",
\          "\t$1local return as ${returntype}",
\          "\t$2* Commands ",
\          "\t$3return m.return",
\          "endfunc"
\          ],
\        "description": "FUNCTION ... ENDFUNC"
\     }
  return ""
endfunc

function snippet_json_scan()
\\  "scan": {
\        "prefix": "scan",
\        "body": [
\          "scan for ${lExpression}",
\          "\t$1* Commands ",
\          "\t$2* exit",
\          "\t$3* loop",
\          "endscan"
\          ],
\        "description": "SCAN ... ENDSCAN"
\     }
  return ""
endfunc

function snippet_json_try()
\\  "try": {
\        "prefix": "try",
\        "body": [
\          "try",
\          "\t$1* tryCommands",
\          "catch to ${oException}",
\          "\t$2* catchCommands",
\          "throw ${eUserExpression}",
\          "finally",
\          "\t$3* finallyCommands",
\          "endtry"
\          ],
\        "description": "TRY...CATCH...FINALLY"
\     }
  return ""
endfunc

function snippet_json_if()
\\  "if": {
\        "prefix": "if",
\        "body": [
\          "if ${lExpression}",
\          "\t$1* Commands",
\          "else",
\          "\t$2* Commands",
\          "endif"
\          ],
\        "description": "IF ... ENDIF"
\     }
  return ""
endfunc

function install_script() as string
  local lsreturn as string
  lsreturn = ""
  lsreturn = m.lsreturn + "md %USERPROFILE%\.vscode\extensions\"+ C_LANGUAGE + "\" + C_CRLF
  lsreturn = m.lsreturn + "md %USERPROFILE%\.vscode\extensions\"+ C_LANGUAGE + "\syntaxes\" + C_CRLF
  lsreturn = m.lsreturn + "md %USERPROFILE%\.vscode\extensions\"+ C_LANGUAGE + "\snippets\" + C_CRLF
  lsreturn = m.lsreturn + "copy " + C_OUTPUT_DIR + C_TMLANGUAGE_FILENAME +" %USERPROFILE%\.vscode\extensions\"+ C_LANGUAGE + "\syntaxes\" + C_CRLF
  lsreturn = m.lsreturn + "copy " + C_OUTPUT_DIR + C_SNIPPETS_JSON_FILENAME +" %USERPROFILE%\.vscode\extensions\"+ C_LANGUAGE + "\snippets\" + C_CRLF
  lsreturn = m.lsreturn + "copy " + C_OUTPUT_DIR + C_PACKAGE_JSON_FILENAME +" %USERPROFILE%\.vscode\extensions\"+ C_LANGUAGE + "\" + C_CRLF
  lsreturn = m.lsreturn + "copy " + C_OUTPUT_DIR + C_CONFIGURATION_JSON_FILENAME +" %USERPROFILE%\.vscode\extensions\"+ C_LANGUAGE + "\" + C_CRLF
  return m.lsreturn
endfunc

function uninstall_script() as string
  return "rd /S/Q %USERPROFILE%\.vscode\extensions\vfp\" + C_CRLF
endfunc

function run_vscode_test() as Logical
  local lsTest as string
  lsTest = getenv("temp") + "\test.prg"
  if messagebox("Run VS Code on " + lsTest +" for test ?", 4+32, C_MESSAGEBOX_TITLE)==6
    =DeleteFileIfExist(m.lsTest)
    =strtofile("* Test.prg " + dtoc(date())+" "+time() + C_CRLF, m.lsTest)
    local lsRun as string
    lsRun = "RUN /N " + getenv("PROGRAMFILES") + "\Microsoft VS Code\Code.exe " + m.lsTest
    &lsRun
    return .t.
  endif
  return .f.
endfunc
