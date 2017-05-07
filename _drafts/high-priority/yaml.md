--- !clarkevans.com/^invoice
invoice: 34843
date   : 2001-01-23
bill-to: &id001
    given  : Chris
    family : Dumars
    address:
        lines: |
            458 Walkman Dr.
            Suite #292
        city    : Royal Oak
        state   : MI
        postal  : 48046
ship-to: *id001
product:
    - sku         : BL394D
      quantity    : 4
      description : Basketball
      price       : 450.00
    - sku         : BL4438H
      quantity    : 1
      description : Super Hoop
      price       : 2392.00
tax  : 251.42
total: 4443.52
comments: >
    Late afternoon is best.
    Backup contact is Nancy
    Billsmer @ 338-4338.
    
    
    
    
    
    
    
    http://www.yaml.org/start.html
    
    
    http://yaml.org/spec/1.2/spec.html#tag/shorthand/
    
    
    
YAML uses three dashes (“---”) to separate directives from document content. This also serves to signal the start of a document if no directives are present. Three dots ( “...”) indicate the end of a document without starting a new one, for use in communication channels.




Explicit typing is denoted with a tag using the exclamation point (“!”) symbol.


YAML represents type information of native data structures with a simple identifier, called a tag. Global tags are URIs and hence globally unique across all applications. The “tag:” URI scheme is recommended for all global YAML tags. In contrast, local tags are specific to a single application. Local tags start with “!”, are not URIs and are not expected to be globally unique. YAML provides a “TAG” directive to make tag notation less verbose; it also offers easy migration from local to global tags. To ensure this, local tags are restricted to the URI character set and use URI character escaping.


6.8.2.1. Tag Handles



Repeated nodes (objects) are first identified by an anchor (marked with the ampersand - “&”), and are then aliased (referenced with an asterisk - “*”) thereafter.    




Scalar content can be written in block notation, using a literal style (indicated by “|”) where all line breaks are significant. Alternatively, they can be written with the folded style (denoted by “>”) where each line break is folded to a space unless it ends an empty or a more-indented line.





Scalar
The content of a scalar node is an opaque datum that can be presented as a series of zero or more Unicode characters.



A block sequence is simply a series of nodes, each denoted by a leading “-” indicator. The “-” indicator must be separated from the node by white space. This allows “-” to be used as the first character in a plain scalar if followed by a non-space character (e.g. “-1”).



Explicit typing is denoted with a tag using the exclamation point (“!”) symbol.

---
not-date: !!str 2002-04-28

picture: !!binary |
 R0lGODlhDAAMAIQAAP//9/X
 17unp5WZmZgAAAOfn515eXv
 Pz7Y6OjuDg4J+fn5OTk6enp
 56enmleECcgggoBADs=

application specific tag: !something |
 The semantics of the tag
 above may be different for
 different documents.
 
 
 
 
6.8. Directives
Directives are instructions to the YAML processor. This specification defines two directives, “YAML” and “TAG”, and reserves all other directives for future use. There is no way to define private directives. This is intentional.

Directives are a presentation detail and must not be used to convey content information.

The “YAML” directive specifies the version of YAML the document conforms to.

%YAML 1.3


The “TAG” directive establishes a tag shorthand notation for specifying node tags. Each “TAG” directive associates a handle with a prefix. This allows for compact and readable tag notation.



YAML represents type information of native data structures with a simple identifier, called a tag. Global tags are URIs and hence globally unique across all applications. The “tag:” URI scheme is recommended for all global YAML tags. In contrast, local tags are specific to a single application. Local tags start with “!”, are not URIs and are not expected to be globally unique. YAML provides a “TAG” directive to make tag notation less verbose; it also offers easy migration from local to global tags. To ensure this, local tags are restricted to the URI character set and use URI character escaping.






http://docs.ansible.com/ansible/YAMLSyntax.html



 