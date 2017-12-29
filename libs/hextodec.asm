;zamiana liczb 16 na postac 10 do wyswietlenia

hex2dec
         
         movwf    dzielona
         
         clrf     dzielonah
         clrf     operandh
         movlw    064h ;dzielenie przez 100

         call     dzielenie
         movf     wynik,w
;dodaje wynik dzielenia przez 100 do ilosci 100-etek w dec100
         movwf    dec100
         ;
dziesiatki
         movf     wynik001,w
         movwf    dzielona
         clrf     dzielonah
;dzielenie przez 10 reszty która została z dzielenia przez 100
         movlw    0ah 
         call     dzielenie

         movf     wynik,w
         movwf    dec10
jednosci
         movf     wynik001,w
;tu są jedności
         movwf    dec1
         return
         
         
         
         
;zamiana ulamka 16 na postac 10 do wyswietlenia
;wyswietlanie z dokladnością do 1000 wartości

hex2dec_ulamek_tysieczny


         movwf    operandl
         clrf     operandh
;mnożę wartość ułamka przez liczbę
;3.90625
;tzn szesnatkowo 3 i w ulamkuh 232 0xe8


         movlw    3
         movwf    mnozona
         clrf     mnozonah
         movlw    0xe8
         movwf    ulamekh
         clrf     ulamekl
         movf    operandl,w
         call     mnozenie
         
                  
         
         movf     wynikh,w
         movwf    dzielonah
         movf     wynik,w
         movwf    dzielona         
         
         
         ;dzielenie przez 256         
         clrf    operandh         
         movlw    0x64
         call     dzielenie         
         movf     wynik,w
;dodaje wynik dzielenia przez 100 do ilosci 100-etek w dec100
         movwf    dec100
         ;

         movf     wynik001,w
         movwf    dzielona
;dzielenie przez 10 reszty która została z dzielenia przez 100
         movlw    0ah 
         call     dzielenie

         movf     wynik,w
         movwf    dec10

         
         movf     wynik001,w
;tu są jedności
         movwf    dec1
         return         