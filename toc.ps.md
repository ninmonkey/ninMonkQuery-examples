# File Listing

Last updated: ```.<{ Get-date | % tostring u }>.``` 

## Images Only

~~~PipeScript{
repo.WriteFileSummary -path . -IncludeExtensionRegex 'png|gif|mp4|jpe?g'
}
~~~

## All Files 

~~~PipeScript{
repo.WriteFileSummary -path . 
}
~~~
