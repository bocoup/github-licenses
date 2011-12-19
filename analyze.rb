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
      content = license.sysread(20000).gsub(/\n/,"")
      if content.match("Permission is hereby granted, free of charge, to any person") 
        puts "MIT License!"
        addToCount(count,"MIT License")  
      elsif content.match("Redistribution and use in source and binary forms") or content.match("Redistribution and use of this software in source and binary forms")
        puts "BSD License!"
        addToCount(count,"BSD License")  
      elsif content.match("ECLIPSE")
        puts "Eclipse License" 
        addToCount(count,"Eclipse License")  
      elsif content.match("GNU Lesser") or content.match("LGPL")
        puts "LGPL"
        addToCount(count,"LGPL")  
      elsif content.match("GNU General") or content.match("GPL")
        puts "GPL"
        addToCount(count,"GPL")  
      elsif content.match("Apache License")
        puts "Apache"
        addToCount(count,"Apache License")  
      elsif content.match("Permission is granted to anyone to use this software for any purpose") or content.match("Permission to use, copy, modify, and distribute this software")
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
      elsif content.match("creativecommons.org") or content.match ("Creative Commons")
        puts "Creative Commons"
        addToCount(count,"Creative Commons")
      elsif content.match("Microsoft Permissive License")
        puts "Microsoft Permissive License"
        addToCount(count,"Microsoft Permissive License")
      elsif content.match(/public domain/i)
        puts "Public Domain"
        addToCount(count,"Public Domain")
      elsif content.match("The Artistic License")
        puts "The Artistic License"
        addToCount(count,"The Artistic License")
      else
        puts "****************other!"
        addToCount(count,"other")  
      end
          
    else
      puts "unable to open"
    end

  license.close


end

count.each { |k,v|
  puts "#{k}\t#{v}"
}
