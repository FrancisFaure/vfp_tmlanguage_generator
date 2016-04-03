
# A **Visual FoxPro** language extension for **Visual Studio Code**

* Microsoft Visual Studio Code website: https://code.visualstudio.com/


## VFP Code in VS Code

* When you open a PRG file in vs Code, the default display is like this

![VSCODE](images/prg-vs-code.png)

## VFP Syntax highlighting (Colorization)

* Download [vfp_tmlanguage_generator.prg](https://github.com/FrancisFaure/vfp_tmlanguage_generator), run in vfp9, and click "Ok" to install.

Using the "Dark Theme" it displays like

![VFP](images/prg-with-vfp-extension.png)

## Personalized Color Theme (for VFP Extension)

* If you want have more colors or personalize your theme: [take a look at...](https://github.com/FrancisFaure/vfp_tmtheme_generator)

Download [vfp_tmtheme_generator.prg](https://github.com/FrancisFaure/vfp_tmtheme_generator), personalize, run in vfp9, and click "Ok" to install.

The personalized theme looks like

![THEME](images/prg-with-vfp-extension-and-theme.png)


## VFP9 integration

To start using VS Code as the external editor (`Modify Command`, `Modify File`) add the following line to the config.fpw file
``` 
TEDIT=/N C:\Program Files (x86)\Microsoft VS Code\Code.exe
```


## Uninstall

**vfp_tmlanguage_generator.prg** : creates a uninstaller script: **"vfp_tmlanguage\uninstall vfp language.cmd"**
* which contains:
```
rd /S/Q %USERPROFILE%\.vscode\extensions\vfp\
```
(Another way using Windows Explorer is to delete **%USERPROFILE%\.vscode\extensions\vfp\**)


## License

[MIT](LICENSE) &copy; Francis FAURE




** Enjoy! **