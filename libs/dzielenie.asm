;to jest dzieleni max 2-bajtowe i z ulamkiem w jednym bajcie
;wynikh
;wynik
;wynik01    
;wynik001  - reszta z dzielenia bajt mlodszy 



dzielenie
	clrf	wynik
	clrf	wynikh
	clrf     reszta_operacji
	movwf	operandl
;jeeli probuje przez 0 to wyjdz z procedury	
	movf	operandl,w
	btfss	STATUS,Z
        goto    brak_zera_przejdz_do_dzielenia
        
        movf   operandh,w
        btfsc   STATUS,Z
	return
	
brak_zera_przejdz_do_dzielenia
petla_dzielenia

	movf	dzielonah,w
	movwf	wynik01
        
      movf	dzielona,w
	movwf	wynik001
        
	movf	operandl,w
	subwf	dzielona,f
	btfss 	STATUS,C
	goto	dzielenie_end;je?eli koniec

      movf	operandh,w
	subwf	dzielonah,f
	btfss 	STATUS,C
	goto	dzielenie_end; jezeli przekroczono zawartosc dzielonah
        
petla_dzielenia2	
	incf	wynik,f
	
	btfsc	STATUS,Z
	incf	wynikh,f
	
	goto	petla_dzielenia
        
dzielenie_end
;je¿eli w operandh jest jakas wartoœæ to ju¿ skoñcz dzielenie, bo
;przekroczono w czasie odejmowania obydwa bajty
      

        movf    operandh,w
        btfss   STATUS,Z
        return

;jezeli operandh == 0 to po przekroczeniu  w czasie odejmowania 
;rejestru dzielona zmniejsz dzielonah, chyba ¿e jest tam 0 to te¿ skoncz

	movf		dzielonah,w

	btfsc		STATUS,Z
	return
	
	decf		dzielonah,f
			
	goto	petla_dzielenia2
	








	
dzielenie_ulamek
         ;jak obliczyc ulamek tzn jaka czesc liczby przez ktora dziele stanowi liczba w wynik01
         ;ulamek   =   wynik01/operandl*256
         
         ;jezeli nie ma ulamka - nic nie zostalo to nie licz ulamka
         
         ;jezeli brak jest wartosci w wynik01 tzn brak jest reszty w starszym bajcie 
         movf     wynik01,w
         
         btfsc    STATUS,Z
         goto     dzielenie_ulamek_1bajt
         

dzielenie_ulamek_2bajty
;kiedy dwa bajty sa reszta wyniku

         movwf    reszta_operacji 
         ;najpierw dziele 0x100/operandl
         
         ;najpierw mnoze reszta z dzielenia * 0x64 (100)
         
         
         movlw    0x01
         movwf    dzielonah
         movlw    0x00
         movwf    dzielona
         clrf	ulamekh
	clrf	ulamekl
         
dzielenie_ulamek_petla_2bajty
         movf	dzielona,w
	;movwf	wynik001
	movf	operandl,w
	subwf	dzielona,f
	btfss 	STATUS,C
	goto	dzielenie_ulamek_end_2bajty
         
         incf     ulamekl,f
         
         goto     dzielenie_ulamek_petla_2bajty
         
dzielenie_ulamek_end_2bajty         
         movf		dzielonah,w

	btfsc		STATUS,Z
	goto     mnoze_przez_wynik01_2bajty
	decf		dzielonah,f
	incf     ulamekl,f		
	goto	dzielenie_ulamek_petla_2bajty
 
mnoze_przez_wynik01_2bajty
         ;mnoze ulamekl przez to co jest w wynik01
         movf     wynik01,w
         movwf    operandl
         
         movf     ulamekl,w
         movwf    mnozona
         
         clrf     wynik01
         
mnoze_przez_wynik01_2bajty_LOOP
         movf     mnozona,w
         addwf    wynik01,f
         
         decf     operandl,f
         
         btfss    STATUS,Z
         goto     mnoze_przez_wynik01_2bajty_LOOP

         return
         
         
         
         
         


;procedury gdy jest tylko 1 bajt reszty 
;dzielenie przez 256          
dzielenie_ulamek_1bajt
         ;;;;;;;;movwf    reszta_operacji 
         
         ;najpierw dziele 0x100/operandl
         
         ;najpierw mnoze reszta z dzielenia * 0x100/ operandl
         
         ;czyli zapisuje jako wynik01  jako dzielonah
         
         movf     wynik001,w
         movwf    dzielonah
         movlw    0x00
         movwf    dzielona
         
         clrf	ulamekh
	 clrf	ulamekl
         
         movf   operandl,w
         
         call   dzielenie
         
         movf   wynik,w
         movwf   wynik01
         
         clrf   wynik001
         
         return
         
 