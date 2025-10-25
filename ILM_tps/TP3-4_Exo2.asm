####################################
#    - ISTIC - L3 Info - ILM -     #
####################################

# ce programme en assembleur est le template pour le TP3-4.

.globl main

.eqv	PRINT_INT, 1
.eqv	PRINT_STRING, 4
.eqv	READ_INT, 5
.eqv    EXIT2, 93

.data
a:		.word 0
b:		.word 0
resultat:	.word 0

invite_a:	.asciz "Entrez un entier (a): "
invite_b:	.asciz "Entrez un entier (b): "
msg_res:	.asciz "Le PGCD de a et b est: "


.text
main:
	
	#Affichage invite_a
	la	a0, invite_a
	li	a7, PRINT_STRING
	ecall
	
	#Demande a Ã  l'utilisateur
	li	a7, READ_INT
	ecall
	la  a1, a
	sw	a0, 0(a1)
	
	#Affichage invite_b
	la	a0, invite_b
	li	a7, PRINT_STRING
	ecall
	
	#Demande b Ã  l'utilisateur
	li a7, READ_INT
	ecall

	la a1,b 
	sw a0,(a1)
	

	# Calcul du PGCD - Exercice 2
	
	la a4,a		#chargement de l'adresse de a dans a4 
	lw a2,(a4)	#recuperation de la valeur de l'adresse dans a2
	
	la a5,b 	#chargement de l'adresse de b dans a5 
	lw a3,(a5)	#recuperation de la valeur de l'adresse dans a3 
		
pgcd_while:beq a2,a3,pgcd_while_end #si b==a alors on arrete la boucle while  

pgcd_if:bge a3,a2,pgcd_endif #si b>=a alors on effectue le else du if qui equivaut ici à pgcd_endif
	
	sub a2,a2,a3	#opération a=a-b
	j pgcd_while	#retour au début de la boucle while
pgcd_endif:	
	sub a3,a3,a2  #opération b=b-a
	
	j pgcd_while #retour au début de la boucle while
			
pgcd_while_end:
	
	la   a5, resultat     # chargement de l'adresse de resultat
        sw   a2, 0(a5)

    
	#Affichage msg_res
	la	a0, msg_res
	li	a7, PRINT_STRING
	ecall
	
	#Affichage resultat
	la	a0, resultat
	lw	a0, 0(a0)
	li	a7, 1
	ecall
	
	# Calcul du PGCD avec fonction - Exercice 3

# Calcul du PGCD avec fonction - Exercice 3
	# ...
	# (Votre code ici)
	# ...
	
	#exit
