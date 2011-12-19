require 'find'

count = Hash.new

def addToCount( hash, key )

  if hash.has_key?(key)
    hash[key] += 1
  else
    hash[key] = 1
  end
  hash
end

 
Find.find('licenses') do |f|

  license = File.open(f,"r")

    unless File.directory? f
      puts f
      content = license.sysread(20000)
      if content.match("Permission is hereby granted, free of charge, to any person") 
        puts "MIT License!"
        addToCount(count,"MIT License")  
      elsif content.match("Redistribution and use in source and binary forms")
        puts "BSD License!"
        addToCount(count,"BSD License")  
      elsif content.match("PROGRAM IS PROVIDED UNDER THE TERMS OF THIS ECLIPSE PUBLIC LICENSE")
        puts "Eclipse License" 
        addToCount(count,"Eclipse License")  
      elsif content.match("GNU General Public License")
        puts "GPL"
        addToCount(count,"GPL")  
      elsif content.match("GNU Lesser General Public License")
        puts "LGPL"
        addToCount(count,"LGPL")  
      elsif content.match("Apache License")
        puts "Apache"
        addToCount(count,"Apache License")  
      elsif content.match("Permission is granted to anyone to use this software for any purpose")
        puts "Do what thou wilt"
        addToCount(count,"Do what thou wilt")  
      elsif content.match("is copyrighted free software by")
        puts "Ruby license"
        addToCount(count,"Ruby License")  
      elsif content.match("This is free and unencumbered software released into the public domain.")
        puts "Unlicense"
        addToCount(count,"Unlicense")  
      elsif content.match("MOZILLA PUBLIC LICENSE")
        puts "Mozilla Public License"
        addToCount(count,"Mozilla Public License")  
      else
        puts "other!"
        addToCount(count,"other")  
      end
          
    else
      puts "unable to open"
    end

  license.close


end

count.each { |k,v|
  puts k, v
}
