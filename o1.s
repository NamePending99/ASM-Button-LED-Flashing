.thumb
.syntax unified

.include "gpio_constants.s"     // Register-adresser og konstanter for GPIO

.text
	.global Start
	
Start:
	// Konstanter for beregning av minneadresse
	LDR R0, =PORT_SIZE

	LDR R1, =LED_PORT
	LDR R2, =BUTTON_PORT
	MUL R1, R1, R0 // Offset Port E
	MUL R2, R2, R0 // Offset Port B

	LDR R3, =GPIO_PORT_DOUTSET
	LDR R4, =GPIO_PORT_DOUTCLR
	LDR R5, =GPIO_PORT_DIN
	LDR R6, =GPIO_BASE

	ADD R0, R1, R6
	ADD R0, R0, R3 // Adresse: GPIO -> PORT_E -> DOUTSET // Skrive opp [1]

	ADD R1, R1, R6
	ADD R1, R1, R4 // Adresse: GPIO -> PORT_E -> DOUTCLR // Skrive ned [0]

	ADD R2, R2, R6
	ADD R2, R2, R5 // Adresse: GPIO -> PORT_B -> DIN

 	// ----------------------------------------------------------//

	MOV R7, #1
	LSL R7, R7, #LED_PIN // Setter 1 ved posisjonen til LED-Pin

	MOV R8, #1
	LSL R8, R8, BUTTON_PIN // Setter 1 ved posisjonen til BUTTON-Pin

Loop:
	LDR R9, [R2] // Henter innholdet i DIN-Registeret til PB0-knappen
	AND R9, R9, R8 // Fjerner alle pinverdier utenom Pin-9 (knapppen)
	CMP R9, R8 // Sjekker verdien på knappen

	BEQ LED_OFF //Setter LED PÅ dersom knappen er PÅ, ellers LED AV

	// Merk at knappen er aktivt HØY
	// Dvs. når knappen IKKE blir trykket, har PB0 verdi 1
	// Når knappen trykkes, blir PB0 satt til verdi 0

LED_ON:
	STR R7, [R0] // Oppdaterer LED-Pin med DOUTSET
	B Loop

LED_OFF:
	STR R7, [R1] // Oppdaterer LED-Pin med DOUTCLR
	B Loop

NOP // Behold denne på bunnen av fila

