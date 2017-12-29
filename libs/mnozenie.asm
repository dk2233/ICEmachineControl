;procedura mnozy dowolną liczbe
;zapisana w ;
;mnozonah i mnozona 
;ulamki w ulamekh i ulamekl
;przez zawrtosc
;rejestru operandl
;i operandh
;wynik obejmuje rowniez ulamki

mnozenie 
         movwf    operandl
         clrf     wynik
         clrf     wynikh
         clrf     wynik01
         clrf     wynik001

mnozenie_l
         ;decf    operandl,f
         
         movf     operandl,w
         btfsc    STATUS,Z
         goto     mnozenie_h
         
         decf     operandl,f
         
         ;btfsc   STATUS,Z
         ;goto    mnozenie_h

mnozenie_l2       
         ;goto             
         movf     mnozonah ,w
         addwf    wynikh,f
         
         movf     mnozona,w
         addwf    wynik,f
         
         btfsc    STATUS,C
         incf     wynikh,f
                  
         movf     ulamekh,w         
         addwf    wynik01,f
         
         btfss    STATUS,C
         goto     ulamek22
;jezeli           
         
         ;movf    
         ;comf    wynik001,w
         
         
         ;btfss   STATUS,Z
         
         
         incf     wynik,f
         
         btfsc    STATUS,Z
         incf     wynikh,f
         
         ;
ulamek22 
         movf     ulamekl,w         
         addwf    wynik001,f
         
         btfss    STATUS,C
         goto     mnozenie_l
         
         incf     wynik01,f
         
         btfsc    STATUS,Z
         incf     wynik,f
         
         
;jezeli po zwiekszeniu bylo 0, tzn ze przekroczylem 256
         
         
         goto     mnozenie_l
         
mnozenie_h
         movf     operandh,w
         btfsc    STATUS,Z
         return
         
         decf     operandh,f
         
         ;btfsc   STATUS,Z
         ;return
         
         decf     operandl,f
         
         goto     mnozenie_l2