# Prat 3.0

## [3.2.31](https://github.com/sylvanaar/prat-3-0/tree/3.2.31) (2019-08-31)
[Full Changelog](https://github.com/sylvanaar/prat-3-0/compare/3.2.30...3.2.31)

- Rework the link protection for some addons with non-standard links (wip for #5)  
- Merge pull request #2 from xionglingfeng/master  
    Fix error when someone come online  
- Merge pull request #3 from amakinen/timestamps-hide-blizz  
    Hide Blizzard chat timestamps when using the Timestamps module  
- Revert changes in module:updateWho  
- Hide Blizzard chat timestamps when using the Timestamps module  
    Previous method of hiding was disabled when Communities UI started using  
    the same setting as Blizzard chat timestamps.  
    The hook gets automatically removed by AceHook's OnEmbedDisable when the  
    module is disabled.  
- Fix error when a new friend come online  
