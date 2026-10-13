package com.djtech.monai.core.media

import org.junit.Assert.assertEquals
import org.junit.Test

class CropMathTest {

    @Test
    fun `no zoom keeps the centered short side`() {
        assertEquals(CropRect(left = 200, top = 0, size = 600), cropRect(1000, 600, CropSpec()))
        assertEquals(CropRect(left = 0, top = 200, size = 600), cropRect(600, 1000, CropSpec()))
    }

    @Test
    fun `zooming in keeps a smaller centered square`() {
        assertEquals(CropRect(left = 350, top = 150, size = 300), cropRect(1000, 600, CropSpec(zoom = 2f)))
    }

    @Test
    fun `moving the photo right shows more of its left side`() {
        // A quarter window is 75 photo pixels, so the window's center moves from 300 to 225.
        assertEquals(CropRect(left = 75, top = 0, size = 300), cropRect(600, 300, CropSpec(offsetX = 0.25f)))
    }

    @Test
    fun `offsets stop at the photo's edge`() {
        assertEquals(
            CropRect(left = 0, top = 0, size = 600),
            cropRect(1000, 600, CropSpec(offsetX = 5f, offsetY = 5f)),
        )
        assertEquals(CropRect(left = 400, top = 0, size = 600), cropRect(1000, 600, CropSpec(offsetX = -5f)))
    }

    @Test
    fun `clamping limits zoom and offsets`() {
        val clamped = CropSpec(
            zoom = 9f,
            offsetX = 9f,
            offsetY = -9f,
            quarterTurns = -1,
        ).clamped(1000, 1000)

        assertEquals(CropSpec.MAX_ZOOM, clamped.zoom)
        // At 2.5x a 1000px photo shows 400px; 300px is left on each side, 0.75 of the window.
        assertEquals(0.75f, clamped.offsetX, 0.0001f)
        assertEquals(-0.75f, clamped.offsetY, 0.0001f)
        assertEquals(3, clamped.quarterTurns)
    }

    @Test
    fun `a quarter turn swaps the sides`() {
        assertEquals(600 to 1000, rotatedSize(1000, 600, quarterTurns = 1))
        assertEquals(1000 to 600, rotatedSize(1000, 600, quarterTurns = 2))
    }
}
