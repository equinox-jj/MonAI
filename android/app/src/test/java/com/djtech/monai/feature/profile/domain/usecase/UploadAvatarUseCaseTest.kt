package com.djtech.monai.feature.profile.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.media.CropSpec
import com.djtech.monai.core.media.FakeImageProcessor
import com.djtech.monai.core.media.ImageEncoding
import com.djtech.monai.core.model.user
import com.djtech.monai.feature.profile.domain.model.AvatarUpload
import com.djtech.monai.feature.profile.domain.model.ProfileError
import com.djtech.monai.feature.profile.domain.repository.FakeProfileRepository
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertSame
import org.junit.Assert.assertTrue
import org.junit.Test

class UploadAvatarUseCaseTest {

    private val repository = FakeProfileRepository(user())
    private val images = FakeImageProcessor()
    private val uploadAvatar = UploadAvatarUseCase(repository, images)

    @Test
    fun `crops to a 512 square webp under 2 MB and uploads it`() = runTest {
        val crop = CropSpec(zoom = 1.5f, offsetX = 0.1f)

        val steps = uploadAvatar("content://photo", crop).toList()

        assertEquals(
            FakeImageProcessor.Crop(
                "content://photo",
                crop,
                side = 512,
                encoding = ImageEncoding.WEBP_LOSSY,
                maxBytes = 2 * 1024 * 1024,
            ),
            images.crops.single(),
        )
        assertSame(images.image, repository.uploadedImages.single())
        assertEquals(
            listOf(
                AvatarUpload.Progress(0.5f),
                AvatarUpload.Progress(1f),
                AvatarUpload.Done(Outcome.Success(Unit)),
            ),
            steps,
        )
    }

    @Test
    fun `a photo that can't be read is unsupported and not uploaded`() = runTest {
        images.image = null

        val steps = uploadAvatar("content://photo", CropSpec()).toList()

        assertEquals(listOf(AvatarUpload.Done(Outcome.Failure(ProfileError.PhotoUnsupported))), steps)
        assertTrue(repository.uploadedImages.isEmpty())
    }
}
