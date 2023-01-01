## Excel-diff

- [ ] auto-extract and compare two xlsx files   
  - [ ] [1] to view the internal error log when something breaks in Pwsh
  - [ ] [2] formulas or tables, a quick summary of "all same" or not

## other

- see: <C:\Users\cppmo_000\SkyDrive\Documents\2022\Pwsh\my_Github\Excellent_sources\Readme.first-todo-checklist.md>

## Excel Related Ideas

To be used with ImportExcel

- [ ] include cell for current path
- [ ] include global variables, like the FullPath for Directory?
- [ ] include lambdas (manually or using the built in share)

- [ ] test formatting "stretch across cell horizontal"
  - Text exists in a single cell.
  - It's stretched across to appear like it's 6 cells wide
  - Good for displaying text without messing with the column widths of the columns
  - 
- [ ] (re)sort sheets order
  - [ ] `xl.SheetOrder -Names  'User', 'Dates', '*'`
  - [ ] `xl.SheetOrder -MoveToFront/End 'User'`
- [ ] add/delete sheets
  - [ ] `xl.AddSheet` `xl.RemoveSheet`
- [ ] hide/show sheets
  - [ ] `xl.HideSheet`

## make worksheets easier to use


Is there 
  - [ ] (1) a hotkey?
  - [ ] or (2) wider scrollbar to see names?
  - [ ] or (3) maybe aliases?
  -  `Pwsh> ExportExcel $Pkg -sheetAbbr 'Ware Inv.' -sheet 'WarehouseInventory' -table 'WarehouseInventory'`
