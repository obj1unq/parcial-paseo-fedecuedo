// Nota 8 (ocho).  
// 1) B+
// 2) B. Manejo incorrecto de parámetros 
// 3) MB- 
// 4) B 
// 5) MB-, delegar en juguete.
// 6) MB.
// 7) MB.
// 8) B-. Preconcicions y excepciones. Desprolijidades en el desgaste.
// Tests no andan!
class Familia {

	var property ninios = #{}

	method puedePasear() {
		// Delegar, dividir en subtareas
		return ninios.all({ ninio => ninio.estaAbrigado() && ninio.llevaCampera() && ninio.promedioNivelCalidad() > 8 && ninio.jugueteAcordeASuEdad() }) // DEBERIA MEJOR EL JUGUETA ACORDE A SU EDAD
	}

	method infaltables() = ninios.map({ ninio => ninio.mejorPrenda() })

	method chiquitos() = ninios.all({ ninio => ninio.esMenor() })

	method pasear() = ninios.forEach({ ninio => ninio.usarPrendas() }) // No chequea precondición.

}

class Ninio {

	var property prendas = #{}
	var property talle
	var property edad

	method usarPrendas() = prendas.forEach({ prenda => prenda.accionDeUsar() })

	method esMenor() {
		return edad < 4
	}

	method cantAbrigos() {
		return prendas.size()
	}

	method llevaCampera() {
		return prendas.any({ prenda => prenda.nivelAbrigo() >= 3 }) // llevar campera es tener al menos un abrigo con  de nivelAbrigo
	}

	method mejorPrenda() {
		return prendas.max({ prenda => prenda.nivelCalidad(self) })
	}

	method promedioNivelCalidad() {
		return prendas.sum({ prenda => prenda.nivelCalidad(self) }) / self.cantAbrigos()
	}

	method estaAbrigado() {
		return self.cantAbrigos() >= 5
	}

	method jugueteAcordeASuEdad() {
		return true
	}

}

class NinioProblematico inherits Ninio {

	var property juguete

	override method estaAbrigado() {
		return self.cantAbrigos() >= 4
	}

	override method jugueteAcordeASuEdad() {
		return self.edad().between(juguete.min(), juguete.max())
	}

}

class Juguete {

	var min
	var max

}

class Prenda {

	var property talle

	method accionDeUsar() {
	// Debería ser abstracto
	}

	method nivelCalidad(ninio) {
		return self.nivelAbrigo() + self.nivelComodidad(ninio)
	}

	method nivelComodidad(ninio) {
		// Desordenado, dividir en subtareas.
		if (ninio.talle() == talle) {
			return 8 - self.restarDesgaste()
		} else {
			return 0
		}
	}

	method restarDesgaste() {
		// Más fácil con min.
		if (self.nivelDesgaste() >= 3) {
			return 3
		} else {
			return self.nivelDesgaste()
		}
	}

	method nivelAbrigo()

	method nivelDesgaste()

}

class PrendaPar inherits Prenda {

	var property izquierdo
	var property derecho

	override method nivelDesgaste() = (izquierdo.nivelDesgaste() + derecho.nivelDesgaste()) / 2

	override method nivelAbrigo() = derecho.nivelAbrigo() + izquierdo.nivelAbrigo()

	// Cuál es la relación entre accionDeUsar, usarPrenda y usar(...). 
	// ¿Porq que no se llaman todos igual?
	override method accionDeUsar() { // DEBERIA CORREGIR ESTO
		derecho.usarPrenda()
		izquierdo.usarPrenda()
	}

	// No se llama nunca.
	method usar(par) { // ¿Por qué recibe un par?
		par.accionDeUsar()
	}

	method restarSiEsMenorDeCuatro(ninio) {
		if (ninio.esMenor()) {
			return 1
		} else {
			return 0
		}
	}

	override method nivelComodidad(ninio) {
		return super(ninio) - self.restarSiEsMenorDeCuatro(ninio)
	}

	method cambiarPar(parB, derechoB) { // Parámetro incorrecto
		parB.derecho(derecho)
		self.derecho(derechoB)
	}

	method intercambiar(unPar) {
		if (self.talle() == unPar.talle()) {
			self.cambiarPar(unPar, unPar.derecho()) // Paso los dos parametros para que derechoB cuando lo modifique siga teniendo el parametro
			// Sería más prolijo usar una variable local en lugar de un parámetro.
		} else self.error('No se puede ejecutar esta accion ya que los pares tienen diferente talle')
	}

}

class PrendaIzquierda {

	var property nivelDesgaste = 0
	var property nivelAbrigo = 1

	method nivelAbrigo() = nivelAbrigo

	method usarPrenda() {
		nivelDesgaste += 0.8
	}

}

class PrendaDerecha {

	var property nivelDesgaste = 0
	var property nivelAbrigo = 1

	method nivelAbrigo() = nivelAbrigo

	method usarPrenda() {
		nivelDesgaste += 1.20
	}

}

class Ropa inherits Prenda {

	var property nivelDesgaste = 0

	override method accionDeUsar() {
		nivelDesgaste += 1
	}

	override method nivelDesgaste() {
		return nivelDesgaste
	}

}

class RopaLiviana inherits Ropa {

	var nivelAbrigo = 1 // Debería ser único para todas las prendas.

	override method nivelAbrigo() = nivelAbrigo

	override method nivelComodidad(ninio) {
		return super(ninio) + 2
	}

}

class RopaPesada inherits Ropa {

	var nivelAbrigo = 3

	override method nivelAbrigo() = nivelAbrigo

	method nivelAbrigo(numero) = nivelAbrigo == numero

}

//Objetos usados para los talles
object xs {

}

object s {

}

object m {

}

object l {

}

object xl {

}

