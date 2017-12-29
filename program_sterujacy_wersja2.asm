           
           LIST   P=PIC16F916
	include  "p16f916.inc"

	__CONFIG _HS_OSC & _MCLRE_ON & _WDT_OFF & _PWRTE_ON & _BOD_OFF &  _CPD_OFF &  _CP_OFF & _DEBUG_OFF
	; __CONFIG _HS_OSC & _MCLRE_ON & _WDT_OFF & _PWRTE_ON & _BOD_OFF &  _CPD_OFF &  _CP_OFF & _DEBUG_ON

;definicje sÄ… w odzielnym pliku

	;include "def_var.h"

czestotliwosc    equ    20000000

         
;2011.03.10
;poczatek programu - tzn inicjacja ekranu    
;program poswiecony jest testowi biblioteki lcd, 
; w celu sprawdzenia i zachowania sposobu dzialania

;do tego dobry algorytm obs³ugi klawiatury

;program obsluguje trzy klawisze - 

;pierwszy - zmiana gora
;drugi - zmiana dol
;trzeci - wybor

;aby zmienic opcje 1 - przechodzimy gwiazdka (innym znacznikiem na t¹ opcjê) oraz wciskamy klawisz enter
; wartoœæ wypisana obok mo¿e byæ zmieniana

;po wybraniu opcji wystarczy wcisn¹æ przycisk Wyboru i opcja jest zapamietana

;w menu s¹ tylko dwie opcje - ekran dwuliniowy

;oraz menu wewnetrzne - dwie inne opcje

;moze byc opcji wiecej - przy przechodzeniu w dol - pojawiaja sie kolejne opcje - gorna znika a pojawia sie nowa dolna, a poprzednia dolna jest na gorze




;menu wewnetrznego

;oraz dobra obsluga przerwan

;klawisze i menu do zmiany na dowolny program


;PORTB -7 - ICD2
;PORTB -6 - ICD2
;PORTB -5 - czujnik DS18B20
;PORTB -4 - 
;PORTB -3 - 
;PORTB -2 - 
;PORTB -1 -  wyjscie sterowania lodówka - sterowanie uruchamianiem kompresora
;PORTB -0 -  wyjscie sterowania lodówka - sterowanie sygna³ drzwi i napiêcie pompy

         
;POrtc - 0 - LCD 4
;POrtc - 1 - LCD 5
;PORTC - 2 - LCD 6
;POrtc - 3 - LCD 7
;POrtc - 4 - RS
;POrtc - 5 - RW 
;POrtc - 6 -   E
;POrtc - 7 -  

;PORTA - 0 - 
;PORTA - 1 - 
;PORTA - 2 - klawisz zmiana
;PORTA - 3 - klawisz enter
;PORTA - 4 - klawisz dol
;PORTA - 5 - lampka do ewentualnego migania



;2011.06.24

;sposób obs³ugi kwarcu trzeba poprawiæ program dzia³a zupe³nie dobrze na kwarcu 4 MHZ 
;ale co z innymi kwarcami?
;zupe³nie dobrze pracuje te¿ na czêstotliwoœci 8 Mhz - zmienia siê tylko dzia³anie i szybkoœæ reakcji klawiszy
; dzia³a te¿ dobrze przy 16 MHz


;2012.04.02


;timer0     - u¿ywany przez klawisze  
;timer1   -    co ile robic pomiary dsem
;timer2  -   uzywany do ds18b20 

;2014.04.06
;ten program s³u¿y do sterowania lodówka AMICA
;dodano czujnik DS18B20
;obs³uga jego poprawiona do wsolpracy z procesorem PIC16F916
;w ten sposób uda³o siê dokonaæ pomiaru temperatury zamra¿arki
;jedyny problem jest z histereza poniewa¿ temperatura zapisywana jest w postaci inwersji - ujemna

; nale¿y zmieniæ ten program tak aby po ponownym uruchomieniu znowu od razu dzia³a³

;usunac miganie LED

;dodaæ drugi czujnik umieszczony w lodowce
; w tej wersji poprawiono obs³ugê regulacji temperatury


         cblock   20h
         
         w_temp
         status_temp
         pclath_temp
        
                       
         n
         tmp
         tmp7
                   
         stan_key
         
       	dec100
	dec10
	dec1
         reszta_operacji
         
        dec100_temp
        dec10_temp
        dec1_temp
        dec01_temp
         
        	wynik001
	wynik01
	wynik
	wynikh

        wynik001_temp
        wynik01_temp
	wynik_temp
	wynikh_temp
                 
         
         
;liczba przez ktora dziele lub mnoze (2 bajtowa)
	operandh
	operandl
	
         mnozonah
         mnozona
         
         
	dzielona
	dzielonah
;starszy bajt ulamku
	ulamekh
;mlodszy bajt ulamku
	ulamekl
         
                  
;dla przerwan     
         
         dane_lcd
         tmp_lcd
         fsr_temp
         
         
	zliczenia_przerwania_TMR0
         
         
                  
         
         
         markers
	    
	markers_klawisze
         markers_pomiary
;menu
         opcja_menu     ; zmienna przechowuj¹ca opcjê przy której jest gwiazdka
         
         polozenie_gwiazdka
         
         znaczniki_klawiszy_menu
         
         stan_menu
         
         
         ;kolejne numery znakow umieszczane w liniach 
         znak_linia
         
  ;tu musza byc rejestry przechowujace opcje w kolejnosci     
         wartosc_opcji_uruchom
         wartosc_opcji_nastawa
         wartosc_opcji_temp
         wartosc_opcji_hex
         
         
       
         
         ile_zliczen_przerwania_TMR2_PWM
         ile_zliczen_TMR2_do_100
         
        wartosc_opcji_czas_wlaczenia01
         
         ile_zliczen_do_pomiaru_temp
         
         tmp_linia
         
         nastawa_temp
         nastawa_temp_01
         
         nastawa_temp_histereza
         nastawa_temp_01_histereza
         jak_duzo_bajtow_odbieram_z_ds
         znak_rozkazu_ds
         polecenie_wysylane
         bajt_CRC
         
         inicjacja_wynik
         
         endc
                  
         cblock   0a0h
         dane_odebrane_z_ds       
         endc
         
         
         
         
;        cblock 110h
                  
;        endc

                  
         cblock   0

         endc
;rejestry nieuzywane wykorzystuje jako dane

;        equ      TMR1L

;        equ      TMR1H

;                 equ      CCPR1H
;linia            equ      CCPR1L







marker_opcji      equ      0x2a






;;;markers
poprzednio_cyfra_zero      equ      0
wartosc_ujemna                equ       1
wykonaj_pomiar                  equ 2
aktualizuj_temp_co_sekunde      equ   3
reguluj                         equ     4
odswiez_ekran                       equ       7  
;znaczniki klawiszy MENU

opcje_po_przycisku_dol     equ      0
opcje_po_przycisku_gora     equ      1
opcja_bez_przycisku        equ       2
                


;stan MENU
menu_glowne       equ      0
wybor_opcji       equ     1                
  
  
  
; 4 opcje od 0 do 3 - tu trzeba wpisaæ jak du¿o opcji

;jezeli 4 opcji to ostatnia jest 3
;jezeli 5 opcji to ostatnia jest 4
koncowa_opcja_menu   equ            3










;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;numery opcji odpowiadaj¹ce po³o¿eniu w menu

numer_opcji_uruchom                equ      0
numer_opcji_nastawa             equ      1
numer_opcji_temperatura        equ   2

;;;;;;;;;;;;;;OPCJE i ich wartoœci
;;;;;;;;;;;;;;;;;;;;;;;;

;mam tu kilka mo¿liwoœci pracy PWM

;b. szybkie i wolniejsze

;1 - na timer2

; 195*X*4/20e6 = 

; ustawienia mno¿nika x1, x5, x20,x100,x256

; max_temp        equ   0xfe
max_temp        equ   0x08
o_ile_zmieniam_temp      equ   1
min_temp        equ   0xe1


max_uruchom              equ      1
o_ile_zmieniam_uruchom       equ      1
min_uruchom        equ      0

ile_TMR2_dla_PWM        equ     0xc3





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; OPCJE KLAWISZY
;;;;;



;tu wpisz ile zliczen TMR0 zanim sprawdzi klawisz
jak_duzo_zliczen_TMR0	equ		3

;definicje klawiszy - port przypisany do kazdego z klawiszy moze byc tym samym portem 

port_klawisz_gora	  	equ		PORTA
port_klawisz_dol       	  	equ		PORTA
port_klawisz_enter 		equ		PORTA


pin_klawisz_gora		equ		4
pin_klawisz_enter		equ		3
pin_klawisz_dol 		equ		2





;stan_key
;w tym rejestrze przechowuje ktore klawisze zostaly wcisniete
;sens tego jest taki, ze musi byc sprawdzone co jakis czas czy ten sam klawisz jest wciaz wcisniety
;wszystkie bity te same co w port_key

wcisniety_jest_klawisz_dol  	equ	0
wcisniety_jest_klawisz_zmiana 	equ	1
wcisniety_jest_klawisz_enter  	equ	2


kb_wcisnieto      equ      6
kb_sprawdz        equ      7












;markers_klawisze

wcisnieto_klawisz		equ		0
minal_czas_zlicz_po_wcisnieciu		equ	 	1


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;						ustawienie LCD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;definicja bitow uzywanych w 4 bitowym przesylaniu 0 - uzywany 1 - nieuzywany
;zwiazane z opcja kasowania
ktore_bity_uzywane_na_lcd     equ   0xf0

ktore_bity_lcd_tris           equ   0x0f
normalne_ustawienie_tris_lcd  equ   b'10000000'

;jaka inicjalizacja ekranu

;;                                1, DL (1 - 8 bit, 0 -4 bit), N - ilosc linii (1 - 2 linie), F = font   
set_4bit		  equ      b'00101000' ;  4bit, 2 linie,font 5x8
;;;                                 DCB  D = display 0 -wylacz, Cursor = 1/0 Blinking=1/0 
display_set         equ      b'00001100' ;ustawia blinking,cursor,

;;;ustawiam entry                           I,S 
set_entry           equ             b'00000110' ;increment I=1, Shift = 1/0










port_lcd          equ      PORTC
port_lcd_e        equ      PORTC
port_lcd_rw       equ      PORTC
port_lcd_rs       equ      PORTC
tris_lcd          equ      TRISC


enable            equ      6
rs                equ      4
rw                equ      5


ile_znakow        equ      16

; jezeli 4 bity lcd znajduja sie obok siebie w rejestrze
;w dolnych 4 bitach to tu ma byc 0
polozenie_danych_lcd  equ    0



port_start_lodowki                equ       PORTB
pin_kompresor                 equ      0
pin_start_all                 equ      1

port_lampka                     equ       PORTA
pin_lampka                      equ     5


polozenie_wartosci    equ      0x09
polozenie_gwiazdki_opcji    equ      0x08


;       pomiary temp
;jak_duzo_zliczen_TMR1_do_pomiaru        equ     0xf

;0x40 - 64 próbki
;0x80  - 128 próbek
;jak_duzo_probek            equ      0x80


;dla 20MHz
;*5
t2con_dla_60us           equ   b'00100100'
;*10
t2con_dla_480us          equ   b'01001100'

;0x3f - dla 4 MHz
;
;movlw   
;movwf    T2CON
czas_oczekiwania_60us         equ   0x3c
czas_oczekiwania_480us        equ   0xf0

port_ds1820      equ      PORTB
tris_ds1820      equ      TRISB
czujnik_ds1820_1  equ      5       

histereza       equ      0x40

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;markers_pomiary     

czy_wykonuje_pomiar_DS1                equ      0
czy_wywoluje_inicjacje_ds_call               equ      1              
czy_czytam_ID_DS1             equ   2     
czekam_na_odczyt_DS1          equ   3        
odczytaj_pomiar_DS1           equ   4
wyswietl_wartosc_dziesietna   equ   5
wysylam_rozkaz_pomiaru          equ     6
wysylam_rozkaz_odbioru          equ   7

jak_duzo_zliczen_TMR1_do_pomiaru        equ     0xa












;
         org      0000h
BEGIN
         ;bsf      PCLATH,3
         ;bcf      PCLATH,4

		 Pagesel inicjacja
         
         goto     inicjacja
                  
         
         org      0004h
         
przerwanie        
;zachowuje rejestr W
         movwf    w_temp
;zachowuje rejestr STATUS
         swapf    STATUS,w
         clrf     STATUS
         movwf    status_temp
                
         movf     PCLATH,w
         movwf    pclath_temp
         clrf     PCLATH
         movf     FSR,w
         movwf    fsr_temp
         
;po to by wszystkie ustawienia banki itd byly na 0    
         ;bcf      STATUS,RP0

         ;btfss    INTCON,RBIE
         ;goto     przerwanie_0
         ;btfss    INTCON,RBIF
         ;goto     przerwanie_0
         
         ;bsf      markers,przerwanie_rb
         
         ;goto     wyjscie_przerwanie
         
         
         ;btfss    PIE1,RCIE
         ;goto     przerwanie_0
         
         banksel  PIE1
         
         btfss    PIE1,TMR2IE
         goto     przerwanie_0
         
         banksel  PIR1
         btfsc    PIR1,TMR2IF
         goto     wykryto_t2
         
         
         
przerwanie_0
        ; banksel  PIE1
        ; btfss    PIE1,ADIE
        ; goto     przerwanie_1
         
        ; banksel  PIR1
         ; btfsc    PIR1,ADIF
         ; goto     przerwanie_pomiaru

przerwanie_1      
        banksel  PIE1
         
         btfss    PIE1,TMR1IE
         goto     przerwanie_2
         
        banksel  PIR1
         btfsc    PIR1,TMR1IF
         goto     wykryto_t1

przerwanie_2  
        banksel  0
         btfss     INTCON,T0IE
         goto      przerwanie_3

         
         btfsc    INTCON,T0IF
         goto     wykryto_t0 
przerwanie_3      

         
przerwanie_4
       
przerwanie_5
         
         
        
         
;        jezeli nic nie wykryto
         
wyjscie_przerwanie
      movf     fsr_temp,w
         movwf    FSR
         movf     pclath_temp,w
         movwf    PCLATH
         swapf    status_temp,w
         movwf    STATUS
         swapf    w_temp,f
         swapf    w_temp,w
         
;        bsf      INTCON,GIE
;        bsf      
         retfie


         
wykryto_t0
;uzywam z klawiszami
         bcf      INTCON,T0IF
		 banksel  0
		 ;decf		zliczenia_przerwania_TMR0,f
		 ;bsf		portlampki,pin_lampki	
         decfsz   zliczenia_przerwania_TMR0,f
         goto     wyjscie_przerwanie                  
;jezeli minelo ilosc zliczen zegara TMR0, trzeba sprawdzic czy dalej jest wcisniety klawisz

         movlw    jak_duzo_zliczen_TMR0
         movwf   	zliczenia_przerwania_TMR0

;jezeli wciaz wcisniety jest przycisk to sprawdz to

;wylacz przerwanie tmr0
         bcf      INTCON,T0IF
         bcf      INTCON,T0IE         

;wlacz znacznik ktory oznacza ze nalezy przejsc do procedury przycisku
         bsf     markers_klawisze,minal_czas_zlicz_po_wcisnieciu 
   
         goto     wyjscie_przerwanie                  
                                   
wykryto_t1
         bcf      PIR1,TMR1IF
         
         ;u¿ywany do kontroli pomiaru temperatury ds - em

         ; co sekunde
         
        
        ; btfsc    port_start_lodowki,pin_start_all
        ; goto    zapal_t1
        
        
        ; bsf     port_start_lodowki,pin_start_all     
        ; goto    wykryto_t1_1
; zapal_t1        
        
        ; bcf     port_start_lodowki,pin_start_all     
         
         
; wykryto_t1_1         
        decfsz  ile_zliczen_do_pomiaru_temp,f
        goto     wyjscie_przerwanie                  
        
         ;wylacz przerwanie tmr1
         
         ; banksel  PIE1
         ; bcf      PIE1,TMR1IE
         ; banksel  0

         
        
        ;je¿eli  min¹³ czas zliczania TMR1 to w³¹cz polecenie pomiaru
        ; bcf     PIR1,ADIF
        ; bsf     ADCON0,GO_DONE
        
        movlw    jak_duzo_zliczen_TMR1_do_pomiaru
        movwf    ile_zliczen_do_pomiaru_temp
         
         btfsc  markers_pomiary,czekam_na_odczyt_DS1
         goto   wykryto_t1_nakaz_odczytu
         
         bsf    markers,wykonaj_pomiar
         
         
         
         goto     wyjscie_przerwanie                  

wykryto_t1_nakaz_odczytu
        bsf      markers_pomiary,odczytaj_pomiar_DS1
        
        ; btfsc    port_lampka,pin_lampka
        ; goto    zapal_t1
        
        
        ; bsf     port_lampka,pin_lampka
        ; goto    wykryto_t1_1
zapal_t1        
        
        ; bcf     port_lampka,pin_lampka
         
         
wykryto_t1_1         
        
        goto     wyjscie_przerwanie                  
        


                           

         

         
wykryto_t2
;uzywam w dzkialaniu czujnika ds
        bcf      PIR1,TMR2IF
        
 
        
        goto     wyjscie_przerwanie



    
        
         
         
         
         
         
         
         



;;;;;;;;;;;;;;;;;;;;;MENU





;;;;;;;;;;;;;;;;;;;;;;;;Procedura która wyœwietla opcje aktualne!
Znajdz_wartosc_opcji
;
;tu wybieram opcje do wyswietlenia obok opcji w menu
;
         
         bcf    markers,poprzednio_cyfra_zero
         movf     tmp,w
         
         
         
         
         movwf    FSR
         
         ;sprawdz czy nie mam wyswietlac temperatury
         
         
         
         
         
         
         movlw    wartosc_opcji_uruchom
         addwf    FSR,f
         
         
         movlw   wartosc_opcji_temp
         xorwf    FSR,w
         btfsc   STATUS,Z
         goto     Znajdz_wartosc_opcji_temper
         
         
         movlw   wartosc_opcji_nastawa
         xorwf    FSR,w
         btfsc   STATUS,Z
         goto     Znajdz_wartosc_opcji_nastawy
         
         
         
         movlw   wartosc_opcji_hex
         xorwf    FSR,w
         btfsc   STATUS,Z
         goto     Znajdz_wartosc_opcji_hex
         
         
         clrf     dzielonah
         ;jezeli wyswietlam czas trwania w³¹czenia
         ;to wtedy mam te¿ starszy bajt do podzia³u
         
         
         movf     INDF,w
         
         call     wyswietl_liczbe_1bajtowa
         
         
         
         return

         
Znajdz_wartosc_opcji_temper
        bcf     markers,wartosc_ujemna
        bsf     markers,aktualizuj_temp_co_sekunde
        
        btfss   wartosc_opcji_temp,7
        goto    Znajdz_wartosc_opcji_temper_1
        
        bsf     markers,wartosc_ujemna
        
        call     check_busy4bit
        movlw   _minus
        call     write_lcd
        call     check_busy4bit
        
        
        
Znajdz_wartosc_opcji_temper_1        
        movf     wartosc_opcji_temp,w
        
        btfsc   wartosc_opcji_temp,7
        comf    wartosc_opcji_temp,w
        
        movwf   dec1
        
        
        movf     wynik01_temp,w
        btfss   wartosc_opcji_temp,7
        goto     Znajdz_wartosc_opcji_temper_2
        
        comf    wynik01_temp,w
        
        
        addlw   1
        
        
        btfsc   STATUS,Z
        incf    dec1,f
        
        
        
Znajdz_wartosc_opcji_temper_2        
        movwf   dec01_temp
        
        movf    dec1,w
        call     wyswietl_liczbe_1bajtowa
        
         call     check_busy4bit
         movlw    _kropka
         call     write_lcd
        
        movf   dec01_temp,w

         call     hex2dec_ulamek_tysieczny
         
         call     check_busy4bit
         
         movf     dec100,w         
         addlw    0x30
         call     write_lcd
         
         call     check_busy4bit
         
         movf     dec10,w         
         addlw    0x30
         call     write_lcd

         call     check_busy4bit
         
         movf     dec1,w         
         addlw    0x30
         call     write_lcd
        ;wyswietl ulamek
        
        return
                
         
         
         








Znajdz_wartosc_opcji_nastawy
;w tej procedurze przeksztalcam liczbe ujemna zapisana jako inwersja liczby bez znaku
; dzieki temu latwiej bedzie porownywac z temperatura z ds
         
         ; clrf   wynik01_temp
         ; clrf   nastawa_temp_01
         
         movf   wartosc_opcji_nastawa,w
         movwf  nastawa_temp
         
         ;jezeli ustawiony 7 bit znaczy ze jest to wiecej niz 127 czyli teraz jest -127
         btfsc   nastawa_temp,7 
         bsf     markers,wartosc_ujemna
         
         ;jezeli jest 0 w nastawie temperatury
         ; movf     wartosc_opcji_nastawa,w
         ; btfs
         ; movf     nastawa_temp_01,w
         
         
         
         btfss    markers,wartosc_ujemna
         goto     Znajdz_wartosc_opcji_nastawy1
         
         comf     nastawa_temp,f         
         
         
         ;btfsc    markers,wartosc_ujemna
         ;incf     nastawa_temp,f
         ; movf     nastawa_temp_01,w
         
         
         
         
         
         ; movf     nastawa_temp,w
         ; bcf    STATUS,C
         ; rrf      nastawa_temp,f
         
         ; movlw  0x80
         ; btfsc  STATUS,C
         
         ; movwf     nastawa_temp_01
         
Znajdz_wartosc_opcji_nastawy1         
         call     check_busy4bit
         movlw  _puste
         
         btfsc  markers,wartosc_ujemna
         movlw  _minus         
         call     write_lcd         
         call     check_busy4bit
         
         
         
         movf     nastawa_temp,w
         call     wyswietl_liczbe_1bajtowa
         
         call     check_busy4bit
         movlw    _kropka
         call     write_lcd
         call     check_busy4bit
         
         movf     nastawa_temp_01,w
         call     hex2dec_ulamek_tysieczny
         
         
         
         movf     dec100,w         
         addlw    0x30
         call     write_lcd
         
         call     check_busy4bit
         
         movf     dec10,w         
         addlw    0x30
         call     write_lcd

         call     check_busy4bit
         
         movf     dec1,w         
         addlw    0x30
         call     write_lcd

         
         bcf     markers,wartosc_ujemna
         return         
         
         
         
         
zamien_na_hex
;jezeli po odjeciu 0a jest niezanaczony bit C
;to znaczy ze dodaj 
         movwf    tmp7
         movlw    0x0a
         subwf    tmp7,w
         btfss    STATUS,C
         goto     cyfry_0_9
         movf     tmp7,w
         addlw    0x37
         return
cyfry_0_9         
         movf     tmp7,w
         addlw    0x30
         return
         
         
         
Znajdz_wartosc_opcji_hex         
         call     check_busy4bit
         
         
         movlw    dane_odebrane_z_ds
         movwf    FSR
         
         
         incf   FSR,f
         
         
         swapf  INDF,w
         andlw  0x0f
         
         call   zamien_na_hex
         call     write_lcd
         call     check_busy4bit
         
         movf   INDF,w
         
         andlw  0x0f
         
         call  zamien_na_hex
         
         call     write_lcd
         call     check_busy4bit
         
         decf   FSR,f
         
         
         swapf  INDF,w
         andlw  0x0f
         
         call  zamien_na_hex
         
         call     write_lcd
         call     check_busy4bit
         
         movf   INDF,w
         
         andlw  0x0f
         
         call  zamien_na_hex
         
         call     write_lcd
         call     check_busy4bit
         
         
         
         return
         









         
         
Znajdz_litere_dla_linii

         movlw HIGH opcja0
         movwf    PCLATH
         
         
         movf     tmp,w
         xorlw    0
         btfsc    STATUS,Z
         goto     opcja0
         
         movf     tmp,w
         xorlw    1
         btfsc    STATUS,Z
         goto     opcja1
         
         movf     tmp,w
         xorlw    2
         btfsc    STATUS,Z
         goto     opcja2


         movf     tmp,w
         xorlw    3
         btfsc    STATUS,Z
         goto     opcja3
         
         ; movf     tmp,w
         ; xorlw    4
         ; btfsc    STATUS,Z
         ; goto     opcja4
         
         ;movf     tmp,w
         ;xorlw    5
         ;btfsc    STATUS,Z
         ; goto     opcja5
         
         ; movf     tmp,w
         ; xorlw    6
         ; btfsc    STATUS,Z
         ; goto     opcja6
         
         
         
         return
         
         







         
         
         
Wyswietlanie_Menu


        bcf     markers,aktualizuj_temp_co_sekunde
         bcf    markers,odswiez_ekran
         ;czyszczenie ca³ego ekranu
         call     check_busy4bit
         movlw    display_clear
         call     send
         ;opcja_menu   - tu przechowywana jest wartoœæ wskazywanej opcji
         
         
         
         
         ;numer opcji jest wartoœci¹ rejestru w którym jest przechowywana tablica z adresami tablic z opcjami ekranu
         call     check_busy4bit
         
         clrf     znak_linia
         ;clrf     znak_linia2
         
         movlw   linia_pierwsza
         addlw    0x01
         call    send
         
Wyswietlanie_Menu_linia_1   


         call     check_busy4bit
              
        
         
         
         
         
         
         ;movf     znak_linia1,w
         ;jezeli jest wyswietlana opcja 0 i przycisk nie byl wcisniety to wyswietl tu opcja0
         
         movf     opcja_menu,w
         movwf    tmp
                
         btfsc    znaczniki_klawiszy_menu,opcje_po_przycisku_dol
         decf     tmp,f
         
         ;ale jezeli jest 0
         
         btfsc    znaczniki_klawiszy_menu,opcje_po_przycisku_gora
         nop
         
         btfsc    znaczniki_klawiszy_menu,opcja_bez_przycisku
         nop
          
        
         
         ;jezeli opcja_menu == 0 wyswietl t¹ opcje:
         
         call     Znajdz_litere_dla_linii
         
         
         clrf     PCLATH

         xorlw    0
         btfsc    STATUS,Z
         goto     Wyswietlanie_Menu_linia_1_Value
         
         incf     znak_linia,f
         call     write_lcd

         goto    Wyswietlanie_Menu_linia_1

Wyswietlanie_Menu_linia_1_Value
         
         call     check_busy4bit
         
         
         ;je¿eli wyœwietlam opcje z kolejnoœci¹ cylindrów wtedy  polozenie wartoœci jest mniejsze
         
         
         ; movlw    numer_opcji_czas_wlacz
         ; xorwf    tmp,w
         ; btfss    STATUS,Z
         ; goto     Wyswiet_Menu_linia_1_Value_Norm
         
         ; movlw    linia_gorna
         ; addlw    polozenie_wartosci
         
; Wyswiet_Menu_linia_1_Value_Norm         
         movlw    linia_gorna
         addlw    polozenie_wartosci
         
         
         call     send

         call     Znajdz_wartosc_opcji
         
         goto     Wyswietl_Menu_linia_2_poczatek
         
Wyswiet_Menu_linia_1_Val_kol_cyl
         movlw    linia_gorna
         addlw    7

         
         call     send

         call     Znajdz_wartosc_opcji
         
         goto     Wyswietl_Menu_linia_2_poczatek
         
Wyswietl_Menu_linia_2_poczatek
      call     check_busy4bit

         movlw   linia_druga
         addlw    0x01
         call    send
 
         clrf     znak_linia
         
Wyswietlanie_Menu_linia_2      
         
         call     check_busy4bit
        

         
         movf     opcja_menu,w
         movwf    tmp
            

         ;na drugiej linii po nacisnieciu przycisku w dol jest wyswietlana wybrana opcja   
         btfsc    znaczniki_klawiszy_menu,opcje_po_przycisku_dol
         nop
         ;na drugiej linii po nacisnieciu przycisku w gore jest wyswietlana opcja nastepna - nie wybrana   
         btfsc    znaczniki_klawiszy_menu,opcje_po_przycisku_gora
         incf     tmp,f
         
         btfsc    znaczniki_klawiszy_menu,opcja_bez_przycisku
         incf     tmp,f
          
                 
                 
         call     Znajdz_litere_dla_linii
          
          clrf     PCLATH

         xorlw    0
         btfsc    STATUS,Z
         goto     Wyswietlanie_Menu_linia_2_Value

         incf     znak_linia,f
         
         call     write_lcd

         goto    Wyswietlanie_Menu_linia_2

Wyswietlanie_Menu_linia_2_Value
         
         call     check_busy4bit
         
         
               ;je¿eli wyœwietlam opcje z kolejnoœci¹ cylindrów wtedy  polozenie wartoœci jest mniejsze
         
         
         
         movlw    linia_dolna
         addlw    polozenie_wartosci
         
         call     send

         call     Znajdz_wartosc_opcji
        
         
         goto     Wyswietlanie_Menu_gwiazdka
         
Wyswiet_Menu_linia_2_Val_kol_cyl
         movlw    linia_dolna
         addlw    7

         
         call     send

         call     Znajdz_wartosc_opcji
         
         goto     Wyswietlanie_Menu_gwiazdka
         
         
         
         
          
Wyswietlanie_Menu_gwiazdka


         ;czyszczenie gwiazdek
         call     check_busy4bit
         movlw    linia_gorna
         call send
         
         
         call     check_busy4bit
         movlw    _puste
         call   write_lcd
         
         call     check_busy4bit
         movlw    linia_dolna
         call send
         
         
         call     check_busy4bit
         movlw    _puste
         call   write_lcd
         
         
         call     check_busy4bit
         
         
         movlw    linia_gorna
         
         btfsc    znaczniki_klawiszy_menu,opcje_po_przycisku_dol
         movlw    linia_dolna
         
         btfsc    znaczniki_klawiszy_menu,opcje_po_przycisku_gora
         movlw    linia_gorna
         
         
         ;je¿eli ustawiono opcjê kolejnoœci to wtedy gwiazdka powinna siê znaleŸæ w innym miejscu
         
         movwf     tmp_linia
         ;jezeli ustawiono zmiane opcji to dodaj jeszcze przesuniecie do opcji -1
         btfss    stan_menu,wybor_opcji
         goto     Wyswie_Menu_gwiazd_normal_opcje
         
         addlw    polozenie_gwiazdki_opcji
         
         movwf    tmp_linia
         
         ;movlw    numer_opcji_kol_cylindr
         ;xorwf    opcja_menu,w
         ;btfss    STATUS,Z
         ;goto      Wyswie_Menu_gwiazd_normal_opcje   
         
         ;movlw    1
         ;subwf    wynikh,f
         

Wyswie_Menu_gwiazd_normal_opcje         
         ;movf     polozenie_gwiazdka,w
         
         movf     tmp_linia,w
         call     send
         
         call     check_busy4bit
         
         movlw    marker_opcji
         call     write_lcd
         
         
         return
         
         
         
         



























         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         




;;;;;;;;;;;;;;;;;;;;;;;;
;;;PROGRAM
;;;;;;;;;;;;;;;;;;;;;;;;;
      include "libs/lcd.h"




      include "libs/lcd4bit.asm"
        
        
      

      include "libs/dzielenie.asm"
      include "libs/hextodec.asm"      
      include "libs/mnozenie.asm"   
      include "libs/wyswietlanie_liczb.asm"  
        
Start
         ;przesuwam kursor o 4 znaki
;        movlw    2
;        addlw    0x0f
      clrf  port_lcd
         call     lcd_init
         ;call     check_busy4bit
         
         ;call     cmd_off
        
         
;        call     check_busy


         movlw    0
         movwf    opcja_menu

         
         bsf znaczniki_klawiszy_menu,opcja_bez_przycisku
         
         bsf  stan_menu,menu_glowne
         
           
         ;test opcji w menu
         
         movlw    0x1
         movwf    wartosc_opcji_uruchom
         
         bsf    port_start_lodowki,pin_start_all      
         
         
         ; movlw    0xed
         movlw    0xe2
         movwf    wartosc_opcji_nastawa
         
         
          ; movlw    1
         
         movlw   jak_duzo_zliczen_TMR1_do_pomiaru
         movwf   ile_zliczen_do_pomiaru_temp
         clrf     znak_linia
         ;clrf     znak_linia2

         movlw    linia_gorna
         movwf    polozenie_gwiazdka
         
         
         
         
;druga strona pamieci tAM umieszczam wszystkie slowa menu

                


	bsf      INTCON,GIE
         bsf      INTCON,PEIE

                  
         call       Wyswietlanie_Menu  
         goto LOOP




         
     











      
      
      
      
      
PIN_HI_1
        banksel  tris_ds1820
        BSF     tris_ds1820, czujnik_ds1820_1          ; high impedance
        banksel  TMR0
        
        RETURN

PIN_LO_1
        BCF     port_ds1820,czujnik_ds1820_1
        banksel  tris_ds1820
        BCF     tris_ds1820, czujnik_ds1820_1         ; low impedance zero
        banksel  TMR0
        
        RETURN
        
send_one_1
         clrf     TMR2
         bcf      PIR1,TMR2IF
         call     PIN_LO_1
         nop
         call     PIN_HI_1
        
petla_send_one_1
         btfss    PIR1,TMR2IF        
         goto     petla_send_one_1
         
         return

send_zero_1
        
         call     PIN_LO_1
         clrf     TMR2
         nop
         
         bcf      PIR1,TMR2IF
         
         bcf      port_ds1820,czujnik_ds1820_1
petla_send_zero_1
         btfss    PIR1,TMR2IF        
         goto     petla_send_zero_1
         call     PIN_HI_1
         
         return

    



       







     
     
     
     
     
     
     
           
inicjacja_ds1820_1

 
         ;bcf      RCSTA1,CREN
         
         
         banksel    tris_ds1820
         bcf      tris_ds1820,czujnik_ds1820_1
       
         
;ustawiam tmr2 na zliczanie 2 
         movlw    czas_oczekiwania_480us
         banksel  PR2
         movwf    PR2
         
;ustawiam 480us      
          banksel  T2CON
         movlw    t2con_dla_480us
         movwf    T2CON
         
         bcf      PIR1,TMR2IF
;wlaczam przerwanie Tmr2
         ;bsf      STATUS,RP0
         ;bsf      PIE1,TMR2IE2
         ;bcf      STATUS,RP0
         call     PIN_HI_1
         call     PIN_LO_1
;daje znacznik ze dotyczy to inicjacji ds1820
         ;bsf      znaczniki_ds,inicjacja
;petla czekania na koniec inicjacji
petla_inicjacji1_1
         
         btfss    PIR1,TMR2IF
         goto     petla_inicjacji1_1
;teraz przelaczam sie na odbior danych z ds1820
         banksel    tris_ds1820
         bsf      tris_ds1820,czujnik_ds1820_1
         
         nop
         banksel     PIR1
         bcf      PIR1,TMR2IF
;sprawdzam czy w ciagu 480us pojawilo sie 0 na porcie czujnika
petla_inicjacji2_1

         btfss    port_ds1820,czujnik_ds1820_1
         goto     petla_inicjacji3_1
         
         btfss    PIR1,TMR2IF         
         goto     petla_inicjacji2_1
         
         goto     blad_inicjacji_ds
         
         
petla_inicjacji3_1
         btfsc    port_ds1820,czujnik_ds1820_1
         goto     inicjacja_ok_1
         btfss    PIR1,TMR2IF
         goto     petla_inicjacji3_1
         
inicjacja_ok_1
         ;btfsc    markers_pomiary,czy_wywoluje_inicjacje_ds_call
         ;return
         
         ;btfsc    markers,czy_rozkaz
         ;goto     wysylanie_danych_rozkaz_1

         ;btfsc    markers,czy_wysylanie_OK
         ;goto     napisz_ok
         movlw     0xff
         movwf     inicjacja_wynik
         return
         
blad_inicjacji_ds         
         movlw     0x01
         movwf     inicjacja_wynik
         return
         
         
      



      

Pomiary_temperatury
        bcf     markers,wykonaj_pomiar
        
        clrf    znak_rozkazu_ds
        
         movlw    9
         movwf    jak_duzo_bajtow_odbieram_z_ds
         
         ; movlw       HIGH rozkaz_pomiaru
         ; movwf       TBLPTRH
      
         ; movlw       LOW rozkaz_pomiaru
         ; movwf       TBLPTRL
         
         bsf         markers_pomiary, wysylam_rozkaz_pomiaru
         
         ;najpierw wyœlij rozkaz pomiaru
         ;wykorzystuje procedury które dzia³aj¹ po wybraniu wysy³ania danych przez polecenie
         ;
         ;        "*D1scc44"
         
         ; bcf    markers,czy_rozkaz
         clrf   znak_rozkazu_ds
         
         call     inicjacja_ds1820_1
         
         call     petla_wysylania_rozkazu_1

         
         ;pozniej czekaj 1 s
         bcf         markers_pomiary, wysylam_rozkaz_pomiaru
         bsf      markers_pomiary,czekam_na_odczyt_DS1
         
         return
     
 

         
;DS18B20
petla_wysylania_rozkazu_1


        btfsc    markers_pomiary, wysylam_rozkaz_pomiaru
        movlw HIGH rozkaz_pomiaru
        
        
        btfsc    markers_pomiary, wysylam_rozkaz_odbioru
        movlw HIGH rozkaz_odbioru
        
        movwf    PCLATH
        
        btfsc    markers_pomiary, wysylam_rozkaz_pomiaru
         call     rozkaz_pomiaru
 
        btfsc    markers_pomiary, wysylam_rozkaz_odbioru
        call rozkaz_odbioru
        
         clrf     PCLATH
         ;movwf        TABLAT,w
	 movwf     polecenie_wysylane
         xorlw     0
         btfsc    STATUS,Z
         return             
          
         incf   znak_rozkazu_ds,f
         
         
         ;jezeli 0 to skocz do wyswietlania slowa z linii 2
         
         
         movlw     czas_oczekiwania_60us      
         ;ustawiam TMR2 na odbieranie
         
         banksel  PR2
         movwf    PR2
         banksel  T2CON
;ustawiam 60us         
         movlw    t2con_dla_60us
         movwf    T2CON
         bcf      PIR1,TMR2IF
         clrf      TMR2
         movlw     8
         movwf     n
         
petla_sending_pomiar_1

        btfss     polecenie_wysylane,0
        call      send_zero_1
        btfsc     polecenie_wysylane,0
        call      send_one_1
        bsf       port_ds1820,czujnik_ds1820_1
        
        bcf       STATUS,C
        rrf       polecenie_wysylane,f
        
        decfsz    n,f
        goto      petla_sending_pomiar_1
         
        goto       petla_wysylania_rozkazu_1
 
     
     
     
     
         

odbierz_pomiary_temp

       bcf  markers_pomiary,odczytaj_pomiar_DS1
       bcf  markers_pomiary,czekam_na_odczyt_DS1
       bcf  markers_pomiary,czy_wykonuje_pomiar_DS1
        clrf    znak_rozkazu_ds
         
         
         
         
         ;najpierw wyœlij rozkaz pomiaru
         ;wykorzystuje procedury które dzia³aj¹ po wybraniu wysy³ania danych przez polecenie
         ;
         ;        "*D1sccbe"
         ; bcf    markers,czy_rozkaz
         
         bsf         markers_pomiary, wysylam_rozkaz_odbioru
         call     inicjacja_ds1820_1
         
         
         ;LFSR     FSR0, dane_odebrane_z_ds
         
         call     petla_wysylania_rozkazu_1
         bcf         markers_pomiary, wysylam_rozkaz_odbioru

         movlw     dane_odebrane_z_ds
         movwf     FSR
         
         call     petla_odbioru_rozkazu_1
         
         
         ;sprawdz CRC
         movlw  dane_odebrane_z_ds
         movwf  FSR        
         ;9 bajt to CRC
         movlw    9
         movwf     n
         
         call     check_CRC_DS
         
         movf     bajt_CRC,w
         ;jezeli 0 to jest ok
         btfsc    STATUS,Z         
         goto      odbierz_pomiary_temp_show_data
         
         
         ; call    wysylac_napis_CRC_notOK
         
        
        
         return

         
         
         
         
         
         

      
    
        
petla_odbioru_rozkazu_1
         movf     jak_duzo_bajtow_odbieram_z_ds,w
         movwf    tmp7
            
         movlw     czas_oczekiwania_60us
         banksel    PR2
         movwf    PR2
         movlw    t2con_dla_60us
         
         banksel        T2CON
         movwf    T2CON
         clrf     TMR2
         bcf      PIR1,TMR2IF   
        
;procedura sprawdza czy ds1820 cos wysyla jezeli tak to sprawdza przez 60 us czy jest choc na chwile 0
;normalnie jezeli ds1820 nic nie wysyla to jest caly czas 1 bez rzadnych zmian
petla_odbioru_z_ds1820_1
        movlw     8
        movwf     n
        clrf      TMR2
        clrf      INDF
        bcf       PIR1,TMR2IF
        
petla_stan_odebranego_bitu_1
         
         call     PIN_LO_1
        
         nop
         nop
         nop
         
         call     PIN_HI_1
         
         
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         
         btfss    port_ds1820,czujnik_ds1820_1
         bcf      STATUS,C
         btfsc    port_ds1820,czujnik_ds1820_1
         bsf      STATUS,C
         rrf     INDF,f
         
czekam_na_kolejny_bit_DS_1
        btfss    PIR1,TMR2IF
        goto      czekam_na_kolejny_bit_DS_1
        
        bcf       PIR1,TMR2IF
        
        decfsz    n,f
        goto      petla_stan_odebranego_bitu_1
        incf      FSR,f
        
;czy juz przeszly wszystkie bajty z DS
        decfsz    tmp7,f
        goto      petla_odbioru_z_ds1820_1

         return      

         
         
         

check_CRC_DS 
         clrf  bajt_CRC
         ;movlw    
   
;tablica danych DS18b20 musi byc w FSR2
check_CRC_DS_loop
         movf INDF,w   
         incf   FSR,f
         xorwf bajt_CRC,f       
         movlw 0     
         
         btfsc bajt_CRC,0 
         xorlw 0x5e       
         
         btfsc bajt_CRC,1 
         xorlw 0xbc 
         
         btfsc bajt_CRC,2 
         xorlw 0x61 
         
         btfsc bajt_CRC,3 
         xorlw 0xc2 
         
         btfsc bajt_CRC,4 
         xorlw 0x9d 
         
         btfsc bajt_CRC,5 
         xorlw 0x23 
         
         btfsc bajt_CRC,6 
         xorlw 0x46 
         
         btfsc bajt_CRC,7 
         xorlw 0x8c 
         
         movwf bajt_CRC   
         
         decfsz n,f 
         goto check_CRC_DS_loop         
                     

         ;movwf bajt_CRC         
 

         return         


         
         

zamien_dane_na_temp
         ;bajt m³odszy
         ;sprawdzam czy mam wartosc ujemna
         
         
         movf   FSR,w
         movwf   wartosc_opcji_hex
         
         incf      FSR,f
         btfss     INDF,7
         goto     zamien_dane_na_temp_dodatnie

        decf    FSR,f
         movlw    1
        subwf    INDF,f
        btfsc    STATUS,C
        goto      zamien_dane_na_temp_dodatnie   
        
        ;bylo 0 w INDF
        ;musze zmniejszyc o 1 pierwszy bajt
        
        incf    FSR,f
        
        decf    INDF,f
          
         
         
         

zamien_dane_na_temp_dodatnie
        
        movlw     dane_odebrane_z_ds
         movwf     FSR
        
         
         movf    INDF,w
         movwf   wynik01
         
         
         
         ;zapisuje w temp_ulamek sam mlodsz¹ po³ówkê pierwszego bajtu
         ;temperatury
         movlw    0x0f
         andwf    wynik01,w
         movwf    wynik01_temp
         swapf    wynik01_temp,f
         swapf    INDF,w
         incf      FSR,f
         andlw    0x0f
         movwf    dec1_temp
         
         movlw    0x0f
         andwf    INDF,w
         movwf    dec10_temp
         swapf    dec10_temp,w
         addwf    dec1_temp,f
         
         ;w bajcie temp_1 jest liczba okreœlaj¹ca szesnastkowo temp
         movf     dec1_temp,w
         movwf    wartosc_opcji_temp
         
         ; movf     temp_ulamek,w
         ; movwf    wynik01_temp
         
         return
         
         
         
         
      
odbierz_pomiary_temp_show_data
         
                  
         movlw     dane_odebrane_z_ds
         movwf     FSR
         
         
         call     zamien_dane_na_temp
        
        
         btfsc   port_start_lodowki,pin_start_all      
         bsf     markers,reguluj
        
         btfss     markers,aktualizuj_temp_co_sekunde
         return
         
         ;wyswietlaj temperature
         
        ; call     check_busy4bit

         ; movlw   linia_druga
         ; addlw    polozenie_wartosci
         ; call    send
 
         ; clrf     znak_linia
         ; call     Znajdz_wartosc_opcji_temper
         
         
         ; call   Wyswietl_menu 
         bsf      markers,odswiez_ekran
         return




     
     
     
     
         
         
         
         
         
         
         
         
         
         
         
         
         
         

         
;procedura rejstracji wcisniecia klawisza 1

;tzn tu trzeba wstawiæ procedury uruchamiane po wcisnieciu i puszczeniu przycisku
; jeden "1"

zarejestrowano_klawisz_dol
;moze byc tak ze po zarejstrowaniu przycisku 1 i po czasie oczekiwania, wciaz jest on wcisniety
;wtedy ponownie uruchom odliczanie TMR0


;jezeli klawisz jest wciaz wcisniety to wlacz przerwanie TMR0 i ustaw znowu sprawdzanie TMR0

      btfsc   port_klawisz_dol,pin_klawisz_dol  
      goto       procedura_po_wci_pusz_dol
;to wykonuje jezeli wciaz jest wcisniety przycisk
; czyli normalnie ponownie uruchamiam TMR0
      
     ;ale z d³u¿szym zliczaniem zanim znów pozwolê sprawdzaæ 
      
      
      call  wlacz_przerwanie_tmr0   
      goto LOOP

      


procedura_po_wci_pusz_dol
;procedura uruchamiana po zarejestrowano wcisniecia i puszczenia przycisku   
   
   
      clrf  stan_key
      clrf  markers_klawisze

procedura_po_wci_pusz_dol_wcisn      
      
       
      
      btfsc       stan_menu,menu_glowne
      goto        klawisz_dol_zmiana_menu

       

          
      btfsc       stan_menu,wybor_opcji
      goto        klawisz_dol_zmiana_wartosci

      
      
klawisz_dol_zmiana_menu      
      ;jezeli byla teraz ustawiona opcja koncowa to nic nie rob w menu
      
      movf        opcja_menu,w
      xorlw       koncowa_opcja_menu
      btfsc       STATUS,Z
      goto        procedura_po_wci_pusz_dol_nic
      
      
      ;zwiekszam o jeden  zmienna opcja_menu  - opcja powinna byc wskazywac kolejna opcje
      
      
      incf        opcja_menu,f
      
      ;zaznaczam ze wlaczam przycisk  dol dla wyswietlania menu
      
      clrf        znaczniki_klawiszy_menu
      
      bsf         znaczniki_klawiszy_menu,opcje_po_przycisku_dol
      
      ;jezeli jest wieksza od zmiennej 
      call       Wyswietlanie_Menu 
        goto  LOOP
procedura_po_wci_pusz_dol_nic      
      clrf        opcja_menu
      
      ;zaznaczam ze wlaczam przycisk  dol dla wyswietlania menu
      
     bsf  stan_menu,menu_glowne
       movlw    linia_gorna
       
         movwf    polozenie_gwiazdka
         clrf        znaczniki_klawiszy_menu
         
         bsf      znaczniki_klawiszy_menu,opcje_po_przycisku_gora
         
      ;jezeli jest wieksza od zmiennej 
      call       Wyswietlanie_Menu 
      
      
      goto  LOOP


      
      


      
 ;;;;DOL  DOL DOWN 
      
klawisz_dol_zmiana_wartosci

         movf     opcja_menu,w
         
         movwf    FSR
         
         movlw    wartosc_opcji_uruchom
         addwf    FSR,f
         
                  
         ;tu sprawdzam która opcja jest wybrana i któr¹ opcjê zmieniam o ile i jakie s¹ 
         ;maxima i mimima danej wartoœci opcji
         
         movf   opcja_menu,w
         xorlw    numer_opcji_uruchom
         btfsc    STATUS,Z
         goto     klawisz_dol_zmiana_uruchom
         
         movf   opcja_menu,w
         xorlw    numer_opcji_nastawa
         btfsc    STATUS,Z
         goto     klawisz_dol_zmiana_nastawa
         
         
         ; movf   opcja_menu,w
         ; xorlw    numer_opcji_temperatura
         ; btfsc    STATUS,Z
         ; goto     klawisz_up_zmiana_temperatura
         
         
         decf     INDF,f
         
         goto     klawisz_dol_zmiana_wartosci_end 
      
     
     
     
     
;opcja  zmiana nastawy temperatury 
      
klawisz_dol_zmiana_nastawa

                 
         movlw    min_temp
         xorwf    INDF,w
         btfss    STATUS,Z
         goto     klawisz_dol_zmiana_nastawa1
         
         movlw    max_temp
         movwf    INDF
         clrf   nastawa_temp_01
         
         goto     klawisz_dol_zmiana_nastawa_end
         
klawisz_dol_zmiana_nastawa1
         ; movlw    o_ile_zmieniam_temp
         ; subwf    INDF,f
         
         movlw      0x80
         addwf      nastawa_temp_01,f
         btfsc          STATUS,C
         decf       INDF,f
         
         
klawisz_dol_zmiana_nastawa_end         
        
         goto     klawisz_dol_zmiana_wartosci_end
         

         
         
         
         
         
         
         
         
         
         
klawisz_dol_zmiana_uruchom
;tutaj uruchamiam dzialanie procedur mierzacych temperature 

      movlw    wartosc_opcji_uruchom
      movwf       FSR


        movlw    min_uruchom
         xorwf    INDF,w
         btfss    STATUS,Z
         goto     klawisz_dol_uruchom_wart
         
         movlw    max_uruchom
         movwf    INDF
         
         
         ;wlaczam prace lodowki
         
         
         bsf      port_start_lodowki,pin_start_all
         bcf      port_start_lodowki,pin_kompresor
         
         
         
         goto     klawisz_dol_zmiana_wartosci_end
         
klawisz_dol_uruchom_wart
         movlw    o_ile_zmieniam_uruchom
         subwf    INDF,f
         ;ten pin jesli ustawiony swiadczy o koniecznosci regulacji
         
         bcf      port_start_lodowki,pin_start_all
         bcf      port_start_lodowki,pin_kompresor
         
         
         goto     klawisz_dol_zmiana_wartosci_end

         

           
         
         
         
         
klawisz_dol_zmiana_wartosci_end      
      ;jezeli jest wieksza od zmiennej 
      call       Wyswietlanie_Menu 
      


   


 
 
      goto  LOOP      


      
      
      
      
      
      
      
      
      
      
      
      

zarejestrowano_klawisz_gora
;moze byc tak ze po zarejstrowaniu przycisku 1 i po czasie oczekiwania, wciaz jest on wcisniety
;wtedy ponownie uruchom odliczanie TMR0

      btfsc   port_klawisz_gora,pin_klawisz_gora
      goto      procedura_po_wci_pusz_gora
;to wykonuje jezeli wciaz jest wcisniety przycisk
; czyli normalnie ponownie uruchamiam TMR0
      
      
      call  wlacz_przerwanie_tmr0   
      goto LOOP

procedura_po_wci_pusz_gora
      ;np zapisuje na linii 2 ekranu numer 2
;bcf		portlampki,pin_lampki	
      clrf  stan_key
      clrf  markers_klawisze

      
      
      
      btfsc       stan_menu,menu_glowne
      goto        klawisz_gora_zmiana_menu

       

          
      btfsc       stan_menu,wybor_opcji
      goto        klawisz_gora_zmiana_wartosci

       
       
       
klawisz_gora_zmiana_menu   

      ;jezeli byla teraz ustawiona opcja koncowa to nic nie rob w menu
      
      movf        opcja_menu,w
      xorlw       0
      btfsc       STATUS,Z
      goto        procedura_po_wci_pusz_gora_nic
      
      
      ;zwiekszam o jeden  zmienna opcja_menu  - opcja powinna byc wskazywac kolejna opcje
      
      
      decf        opcja_menu,f
      
      ;zaznaczam ze wlaczam przycisk  dol dla wyswietlania menu
      
      clrf        znaczniki_klawiszy_menu
      
      bsf         znaczniki_klawiszy_menu,opcje_po_przycisku_gora
      
      ;jezeli jest wieksza od zmiennej 
      call       Wyswietlanie_Menu 

      
procedura_po_wci_pusz_gora_nic     
       goto  LOOP
       









      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
klawisz_gora_zmiana_wartosci

         movf     opcja_menu,w
         
         movwf    FSR
         
         movlw    wartosc_opcji_uruchom
         addwf    FSR,f
         
                  
               ;tu sprawdzam która opcja jest wybrana i któr¹ opcjê zmieniam o ile i jakie s¹ 
         ;maxima i mimima danej wartoœci opcji
         
         movf   opcja_menu,w
         xorlw    numer_opcji_uruchom
         btfsc    STATUS,Z
         goto     klawisz_up_zmiana_uruchom
         
         movf   opcja_menu,w
         xorlw    numer_opcji_nastawa
         btfsc    STATUS,Z
         goto     klawisz_up_zmiana_nastawa
         
         
         ; movf   opcja_menu,w
         ; xorlw    numer_opcji_temperatura
         ; btfsc    STATUS,Z
         ; goto     klawisz_up_zmiana_temperatura
         
         
         incf     INDF,f
         
         goto     klawisz_up_zmiana_wartosci_end 
      
     
     
     
     
;opcja  zmiana nastawy temperatury 
      
klawisz_up_zmiana_nastawa

                 
         movlw    max_temp
         xorwf    INDF,w
         btfss    STATUS,Z
         goto     klawisz_up_1_pr_zmiana
         
         movlw    min_temp
         movwf    INDF
         
         clrf     nastawa_temp_01
         
         goto     klawisz_up_zmiana_wartosci_end
         
klawisz_up_1_pr_zmiana
         ; movlw    o_ile_zmieniam_temp
         ; addwf    INDF,f
         
         movlw          0x80
         ; subwf          nastawa_temp_01,f
         subwf          nastawa_temp_01,f
         btfss          STATUS,C
         incf           INDF,f
         
klawisz_up_1_pr_zmiana_end         
        
         goto     klawisz_up_zmiana_wartosci_end
         

         
         
         
         
         
         
         
         
         
         
klawisz_up_zmiana_uruchom
;tutaj uruchamiam dzialanie procedur mierzacych temperature 

      movlw    wartosc_opcji_uruchom
      movwf       FSR


        movlw    max_uruchom
         xorwf    INDF,w
         btfss    STATUS,Z
         goto     klawisz_up_uruchom_wart
         
         movlw    min_uruchom
         movwf    INDF
         
         
         ;wylaczam prace lodowki
         
         
         bcf      port_start_lodowki,pin_start_all
         bcf      port_start_lodowki,pin_kompresor
         
         
         
         goto     klawisz_up_zmiana_wartosci_end
         
klawisz_up_uruchom_wart
         movlw    o_ile_zmieniam_uruchom
         addwf    INDF,f
         ;ten pin jesli ustawiony swiadczy o koniecznosci regulacji
         
         bsf      port_start_lodowki,pin_start_all
         bcf      port_start_lodowki,pin_kompresor
         
         
         goto     klawisz_up_zmiana_wartosci_end

         

           
         
         
         
         
klawisz_up_zmiana_wartosci_end      
      ;jezeli jest wieksza od zmiennej 
      call       Wyswietlanie_Menu 
      


   


 
 
      goto  LOOP      
            
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
;;;;;;;;;;;;;;

;                                                         ENTER

;;;;;      
      
      
      
      
      
      
      
zarejestrowano_klawisz_enter
;moze byc tak ze po zarejstrowaniu przycisku 1 i po czasie oczekiwania, wciaz jest on wcisniety
;wtedy ponownie uruchom odliczanie TMR0

      btfsc   port_klawisz_enter,pin_klawisz_enter
      goto        procedura_po_wci_pusz_enter
;to wykonuje jezeli wciaz jest wcisniety przycisk
; czyli normalnie ponownie uruchamiam TMR0
      
      
      call  wlacz_przerwanie_tmr0   
      goto LOOP


procedura_po_wci_pusz_enter
      

      clrf  stan_key
      clrf  markers_klawisze

      
      
      btfsc       stan_menu,menu_glowne
      goto        wybrano_zmiane_opcji
      
      
      btfsc       stan_menu,wybor_opcji
      goto        wybrano_menu_glowne
      
wybrano_zmiane_opcji

         ;je¿eli ustawiona jest opcja wyœwietlaj¹ca pomiar temperatury
         ;czasu to nie przechodŸ do zmiany opcji
         
         
         movf   opcja_menu,w
         xorlw    numer_opcji_temperatura
         btfsc    STATUS,Z
         goto     LOOP

         
         
         
         
         

         bcf     stan_menu,menu_glowne
         bsf     stan_menu,wybor_opcji
         
      
      ;jezeli jest wieksza od zmiennej 
      call       Wyswietlanie_Menu 
         
      goto  LOOP

wybrano_menu_glowne
         bsf     stan_menu,menu_glowne
         bcf     stan_menu,wybor_opcji
         
         ; clrf        znaczniki_klawiszy_menu
      
     ; bsf         znaczniki_klawiszy_menu,opcja_bez_przycisku
      
      
      call     check_busy4bit
         movlw    linia_gorna
         addlw    polozenie_wartosci-1
         call send
         
         
         call     check_busy4bit
         movlw    _puste
         call   write_lcd
         
         call     check_busy4bit
         movlw    linia_dolna
         addlw    polozenie_wartosci-1
         call send
         
         
         call     check_busy4bit
         movlw    _puste
         call   write_lcd
      
      
      
      
    
      ;jezeli jest wieksza od zmiennej 
      call       Wyswietlanie_Menu 
      
         
      goto  LOOP
      
            
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      

;procedura odliczajaca jeden z timerow

wlacz_przerwanie_tmr0
;tu wlaczane jest przerwanie jednego z zegara
; w tym wypadku zegar TMR0
;mo¿na u¿yc innego dostepnego dla okreslonego procesora
;ustawienia dowolne - minimum oko³o 0,1 sekundy oczekiwania po nacisnieciu klawisza

;ustawienia timera0
; w procedurze inicjacyjnej
; procesor ma czestotliwosc 8 Mhz
;wtedy jedno zliczenie to 1/2000000s
; a wiec przelicznik 1:256 (czyli przerwanie wystepuje po 256*256/2000000)
;czyli oko³o 32 ms
; zrobimy wiec 3 zliczenia zanim zarejestruje przycisk
     
      ;tu wlaczam tylko przerwanie TMR0

      movlw    jak_duzo_zliczen_TMR0
      movwf   	zliczenia_przerwania_TMR0

      clrf  TMR0

      bcf   INTCON,T0IF
      bsf   INTCON,T0IE
     

      banksel OPTION_REG

      bsf    OPTION_REG,INTEDG

      banksel 0
     
      return
   

wcisnieto_klawisz_dol

           
            
      btfsc   markers_klawisze,wcisnieto_klawisz
      return

      
      bsf   markers_klawisze,wcisnieto_klawisz

      clrf  stan_key

      bsf   stan_key,wcisniety_jest_klawisz_dol

	;wlaczam przerwanie zeby sprawdzic czas po ktorym ma byc zarejestrowany klawisz
      
      goto  wlacz_przerwanie_tmr0      


      
      

wcisnieto_klawisz_gora

           
            
      btfsc   markers_klawisze,wcisnieto_klawisz
      return

      
      bsf   markers_klawisze,wcisnieto_klawisz

      clrf  stan_key

      bsf   stan_key,wcisniety_jest_klawisz_zmiana

	;wlaczam przerwanie zeby sprawdzic czas po ktorym ma byc zarejestrowany klawisz
      
      goto  wlacz_przerwanie_tmr0      


wcisnieto_klawisz_enter
     
      
            
      btfsc   markers_klawisze,wcisnieto_klawisz
      return

      
      bsf   markers_klawisze,wcisnieto_klawisz

      clrf  stan_key

      bsf   stan_key,wcisniety_jest_klawisz_enter

	;wlaczam przerwanie zeby sprawdzic czas po ktorym ma byc zarejestrowany klawisz
      
      goto  wlacz_przerwanie_tmr0      

      
      
      
      
      
      
      
      
      
      

regulacja
        
      ; tu jest   procedura regulacji kanalu 1
        
      bcf       markers,reguluj
         
         
         
;porownaj wartosc pomierzona z zadana
; wartosc_opcji_nastawa
; wartosc_opcji_temp
        movf      wartosc_opcji_nastawa,w
        movwf    nastawa_temp_histereza
        
        movf      nastawa_temp_01,w
        movwf    nastawa_temp_01_histereza


        btfss  nastawa_temp_histereza,7
         goto   nastawa_jest_wieksza_od_0_inna_regulacja

        
;uwzgledniam histereze

        btfsc     port_start_lodowki,pin_kompresor
        goto      zwieksz_temp_o_histereze
        
        ;zmniejsz temperature nastawy o histereze
        ;bo jest wylaczone
        movlw     histereza
        subwf     nastawa_temp_01_histereza,f
        
        btfss    STATUS,C
        incf      nastawa_temp_histereza,f
        
        goto     regulacja_po_histerezie
zwieksz_temp_o_histereze    
        ;jest wlaczone odejmij zwieksz ulamek temp o histereze
        
        ;jesli jest np ustawiona 0xed  czyli -18,5  
        ;to w ulamku jest 0x80
        ;to wtedy dodajac histereze np 0x30
        ;wylaczy dopiero gdy jest temperatura -18, 0xb0 w ulamku czyli przy -18,675
        ;wlaczy ponownie gdy wzrosnie temperatura do -18,3125
        movlw     histereza
        addwf     nastawa_temp_01_histereza,f
        
        btfsc    STATUS,C
        decf      nastawa_temp_histereza,f


regulacja_po_histerezie        
         
;gdy nastawa jest ujemna
         
         ;jezeli aktualny pomiar jest wiekszy od 0
         ;czyli nastawilem ujemnie
         ;ale mam +
         
         btfss   wartosc_opcji_temp,7
         goto    wlacz_kompresor_lodowki
         
         
         ;jezeli obydwie sa ujemna to sprawdzam ktora wartosc jest mniejsza
         ;zalozmy ze ustawiona wartosc jest -10 czyli 0xf5
         ;jezeli zmierzona jest wieksza znaczy ze trzeba wciaz chlodzic
         ;np -8  to 0xf7
         
         movf     nastawa_temp_histereza,w
         ;pomiarh - jaka_wartosc_regulujeH
         ;  file  - Wreg
         ; wartosc_opcji_temp - wartosc_opcji_nastawa
         subwf    wartosc_opcji_temp,w
;sprawdz czy to samo czy wieksze
         btfsc    STATUS,Z
         goto     sa_rowne_sprawdz_ulamek
         ;C jest ustawione przy odejmowaniu jesli wynik nie byl wartoscia ujemna czyli jesli 
         ;wartosc_opcji_temp > wartosc_opcji_nastawa
         ;np 0xf8 > 0xf5
         ; czyli -7   i  -10
         btfsc    STATUS,C 
         goto     wlacz_kompresor_lodowki
;tzn nastawa<pomiaru temp  wiec wylacz grzanie
         goto     off_kompresor_lodowki
                           
sa_rowne_sprawdz_ulamek
;tak samo

        movf    wynik01_temp,w
        
;ulamek z pomiaru dsa jest inwersja prawdziwej wartosci 
        btfss   nastawa_temp_histereza,7
        goto   sa_rowne_sprawdz_ulamek_bez_odw

        comf    wynik01_temp,w
        ; addlw   1
        
sa_rowne_sprawdz_ulamek_bez_odw        
        ;od nastawy odejmuje ulamek temperatury zmierzonej
        ;  nastawa_temp_01_histereza  -  wynik01_temp
        ;jesli nastawa_temp_01 > wynik01_temp  wtedy C jest ustawione  
        ;co oznacza ze temp jest nizsza niz ustawiona
        subwf   nastawa_temp_01_histereza,w
        btfss   STATUS,C
        goto    off_kompresor_lodowki
        
        goto     wlacz_kompresor_lodowki
        
                


        
wlacz_kompresor_lodowki
        bsf     port_start_lodowki,pin_kompresor
        
        return
         
; nastawa_jest_wieksza_od_0         
off_kompresor_lodowki
        bcf     port_start_lodowki,pin_kompresor
        
        return       
      
      
      
      
      

;gdy nastawa jest dodatnia analize przeprowadza sie na odwrot niz w procedurach dla nastawy
;ujemnej
;np histereza przy wylaczeniu mocy - temp powinna wzrosnac -np z 5 na 5,3 zeby znowu wlaczyc
;w przypadku nastawy ujemnej - 5 musialo wzrosnac na -4,7

nastawa_jest_wieksza_od_0_inna_regulacja
        
;uwzgledniam histereze

        btfsc     port_start_lodowki,pin_kompresor
        goto      zmniejsz_temp_o_histereze
        
        ;zmniejsz temperature nastawy o histereze
        ;bo jest wylaczone
        movlw     histereza
        addwf     nastawa_temp_01_histereza,f
        
        btfsc    STATUS,C
        incf      nastawa_temp_histereza,f
        
        goto     regulacja_po_histerezie_dodatnia
zmniejsz_temp_o_histereze    
        ;jest wlaczone odejmij zwieksz ulamek temp o histereze
        
        ;jesli jest np ustawiona 0x05  czyli 5  
        ;to w ulamku jest 0x00
        ;to wtedy dodajac histereze np 0x30
        ;wylaczy dopiero gdy jest temperatura 5, 0x30 w ulamku czyli przy 4,635
        ;wlaczy ponownie gdy wzrosnie temperatura do 5,375
        movlw     histereza
        subwf     nastawa_temp_01_histereza,f
        
        btfss    STATUS,C
        decf      nastawa_temp_histereza,f


      
regulacja_po_histerezie_dodatnia      
      ; goto     wlacz_kompresor_lodowki
      
      
      
      ;jezeli aktualny pomiar jest mniejszy od 0
         ;tzn ze ponizej nastawy
         btfsc   wartosc_opcji_temp,7
         goto    off_kompresor_lodowki
         
         
         ;jezeli obydwie sa dodatnie to sprawdzam ktora wartosc jest wieksza
         ;zalozmy ze ustawiona wartosc jest 5 czyli 0x05
         ;jezeli zmierzona jest wieksza znaczy ze trzeba wciaz chlodzic
         ;np 6  to 0x06
         
         movf     nastawa_temp_histereza,w
         ;pomiarh - jaka_wartosc_regulujeH
         ;  file  - Wreg
         ; wartosc_opcji_temp - wartosc_opcji_nastawa
         subwf    wartosc_opcji_temp,w
;sprawdz czy to samo czy wieksze
         btfsc    STATUS,Z
         goto     sa_rowne_sprawdz_ulamek_dodatnie
         ;C jest ustawione przy odejmowaniu jesli wynik nie byl wartoscia ujemna czyli jesli 
         ;wartosc_opcji_temp > wartosc_opcji_nastawa
         ;np 0x07 > 0x05
         ; czyli 7   i  5 - temperatura za wysoka trzeba chlodzic
         btfsc    STATUS,C 
         goto     wlacz_kompresor_lodowki
         
         
        ;tzn nastawa>pomiaru temp  wiec wylacz grzanie
         goto     off_kompresor_lodowki

sa_rowne_sprawdz_ulamek_dodatnie
;tak samo

        movf    wynik01_temp,w
        
        
sa_rowne_sprawdz_ulamek_bez_odw2        
        ;od nastawy odejmuje ulamek temperatury zmierzonej
        ;  nastawa_temp_01_histereza  -  wynik01_temp
        ;np 5.5  - 5.2
        ;jesli nastawa_temp_01 > wynik01_temp  wtedy C jest ustawione  
        ;co oznacza ze temp jest nizsza niz ustawiona
        subwf   nastawa_temp_01_histereza,w
        btfsc   STATUS,C
        goto    off_kompresor_lodowki
        
        goto     wlacz_kompresor_lodowki
        
                





         
;;;;;;;;;;;;;;;   G£ÓWNA PÊTLA!      
      
      
      
      

                  
LOOP
        btfsc   markers,reguluj
        call    regulacja

        btfsc   markers,wykonaj_pomiar
        call    Pomiary_temperatury
         
         
        btfsc       markers_pomiary,odczytaj_pomiar_DS1
        call      odbierz_pomiary_temp
       
         
         
        btfsc   markers,odswiez_ekran
        call    Wyswietlanie_Menu
         
      
         ; btfsc    markers,zmierz_temperature
         ; call     Zmierz_DS18b20
      
LOOP_klawisze         
      btfss       markers_klawisze,minal_czas_zlicz_po_wcisnieciu
      goto        LOOP_sprawdz_wcisniecie_klawisz


      bcf       markers_klawisze,minal_czas_zlicz_po_wcisnieciu


LOOP_sprawdz_ktory_wcisnieto
;ta procedura jest uruchamiana po tym jak zostanie zliczony pewien czas przez jeden z timerow
; i w tym czasie wciaz byl wcisniety przycisk
;czyli to jest rzeczywista procedura uruchamiania opcji menu

      btfsc   stan_key,wcisniety_jest_klawisz_dol
      goto    zarejestrowano_klawisz_dol
                  
      btfsc    stan_key,wcisniety_jest_klawisz_zmiana
      goto     zarejestrowano_klawisz_gora
                           
      btfsc    stan_key,wcisniety_jest_klawisz_enter
      goto     zarejestrowano_klawisz_enter
         
         
                  
         
         
         
LOOP_sprawdz_wcisniecie_klawisz
;jezeli juz zarejestrowano klawisz to nie sprawdzaj klawiszy
         btfsc   markers_klawisze,wcisnieto_klawisz
         goto     LOOP2

      btfss   port_klawisz_dol,pin_klawisz_dol
      call    wcisnieto_klawisz_dol
                  
      btfss    port_klawisz_gora,pin_klawisz_gora
      call     wcisnieto_klawisz_gora
                           
      btfss    port_klawisz_enter,pin_klawisz_enter
      call     wcisnieto_klawisz_enter
         


LOOP2                            
       
    
         

         goto     LOOP
         
         
            
        
        
  



            
        
        
        
        
         
         
         
         
         

        
        
        
        
        
        
        
        
        
        
        
         
; org    800h
;ta funkcja zlicza nacisniecia klawisza rb0Ã³Å‚Å„Å¼Ä…
;funkcja odczekuj?ca



         
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;POCZATEK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;       
         org      0800h    


                
inicjacja
         clrf    STATUS ;czyszcze status
         
         ;clrf    czas;
         clrf     PORTA
         clrf     PORTB
         clrf     PORTC
         
         ;clrf ADCON0
         ;wylaczony
         movlw  b'00000000'
         movwf  ADCON0
         ;movlw   0x15
         ;movwf   tmp
         ;rlf     tmp,f
         ;movlw   0x93
         ;xorwf   tmp,w
;ustawiam TMR1
        
         movlw    b'00110101'       
         movwf    T1CON
;przerwania
         clrf     INTCON
         bcf      INTCON,GIE
         bcf      INTCON,PEIE
         
         bcf     INTCON,T0IE
         bcf     INTCON,T0IF
         ;bcf      TRISE,PSPMODE
         bcf      SSPCON,SSPEN
         BCF      RCSTA,SPEN
         
         ;movlw   b'00000000'       ;wszystkie linie na wysoko
         ;ovwf    PORTB
         movlw    0
         movwf    CCP1CON
         ;BCF     
         clrf     TMR2
BEGIN2lcd_init

        bcf     PIR1,TMR1IF        

;tu wpisuje ustawienia dla drugiego banku
         bsf      STATUS,RP0        ;bank 1


         clrf     PIE1
         clrf     PIE2
         
         bsf      PIE1,TMR1IE
         bcf      PIE1,ADIE
     ;ustawiam na wyjscia 1 -wejscie
        ;movlw   b'11111111'
         
         movlw    b'00111111'
         movwf    TRISA
         
         
         movlw   b'11111100'
         movwf    TRISB
                  
        movlw   b'10000000'
         movwf    TRISC
         
;tu sie zminienia dla kabli
        ;movlw   b'00000000'
         ;movwf    TRISD
         
         ;movlw   b'00000000'
         ;movwf    TRISE
         
         
;ustawienia timera0
; procesor ma czestotliwosc 20 Mhz
;wtedy jedno zliczenie to 1/2000000s
; a wiec przelicznik 1:256 (czyli przerwanie wystepuje po 256*256/5000000)
;czyli oko³o 13 ms
; zrobimy wiec 3 zliczenia zanim zarejestruje przycisk
        movlw     b'11010111'
        movwf     OPTION_REG
 
;wylaczam wszystkie analogowe wejscia
         movlw    b'01100000'
         movwf    ADCON1
;90  czyli 5a
;50      32
;210(200us) d2
;196(190us) c4    
;        movlw    b'11010010'
         movlw    0x37
         movwf    PR2
         
;bank 0
       

         movlw    0x1a
         movwf    SPBRG
         
         clrf     TXSTA
                 
;wylaczam przerwanie szeregu
         bcf      PIE1,RCIE
;        bsf      PIE1,TXIE
         bcf      STATUS,RP0
         clrf     RCSTA
         
         
         ;wylaczam modul LCD
         
         banksel LCDCON
         clrf     LCDCON
         
         banksel  ANSEL
         movlw          b'00000000'
         movwf  ANSEL
         
         banksel CMCON0
         movlw  b'00000111'
         movwf  CMCON0
         
         banksel        0
         
         
         
;wyczyscic trzeba pamiec na zmienne
;jezeli tego nie zrobie to
;po wlaczeniu zasilani moga pojawic
; sie problemy bo moga tam byc losowe dane

         movlw    0x20
         movwf    FSR
next
         ;movlw   0
         clrf     INDF
         INCF     FSR,f
         movlw    07fh
         xorwf    FSR,w
         BTFSS    STATUS,Z
         goto     next
         
         
         
         
         movlw    0a0h
         movwf    FSR
next2
         clrf     INDF
         INCF     FSR,f
         movlw    0ffh
         xorwf    FSR,w
         BTFSS    STATUS,Z
         goto     next2
         
    
;w przyadku testowania

         ;movlw    0xa0
         ;movwf    FSR
         

         
         Pagesel Start
         
         goto    Start
                  



      org      0900h    


;;;;;;;;;;;;;;ZBIOR NAPISóW
;;;kolejne poziomy menu pojawiaja sie w wybranych czescich ekranu

 

     
opcja0
         movf     znak_linia,w
         addwf    PCL,f
         dt "uruchom  ",0
         
opcja1  
         movf     znak_linia,w
         addwf    PCL,f
         dt     "nastawa  ",0
         
         
opcja2         
         movf     znak_linia,w
         addwf    PCL,f
         dt     "temp ",0

opcja3         
         movf     znak_linia,w
         addwf    PCL,f
         dt     "hex. ",0

         
         
opcja4
         movf     znak_linia,w
         addwf    PCL,f
         dt     "uruchom",0

    
         
rozkaz_pomiaru         
        movf     znak_rozkazu_ds,w
         addwf    PCL,f         
         dt   0xcc,0x44,0x00

rozkaz_odbioru
        movf     znak_rozkazu_ds,w
         addwf    PCL,f
         dt   0xcc,0xbe,0x00
         
rozkac_id
        movf     znak_rozkazu_ds,w
         addwf    PCL,f
         dt       0x33,0x00
         
         
         end